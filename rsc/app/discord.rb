# frozen_string_literal: true

require 'json'
require 'net/http'

module App
  class Discord < Pigeon
    def deliver
      validate_fields :discord_channel, :discord_token, :project_name, :env
      @discord_channel = @options[:discord_channel]
      @discord_token = @options[:discord_token]
      remove_sensitive_data! :discord_channel, :discord_token
      template = create_template
      send_template(template)
    end

    private

    def create_template
      case @options[:action]
      when 'start_sync' then start_sync_template
      when 'finished_sync' then finished_sync_template
      else
        default_template
      end
    end

    def start_sync_template
      content = read_template('start_sync.md.erb')
      render(content)
    end

    def finished_sync_template
      content = read_template('finished_sync.md.erb')
      render(content)
    end

    def default_template
      content = read_template('default.md.erb')
      render(content)
    end

    def send_template(content)
      uri = URI(discord_url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true

      request = Net::HTTP::Post.new(uri)
      request['Content-Type'] = 'application/json'

      request.body = { content: }.to_json
      response = https.request(request)
      raise response.body unless response.code.to_s.start_with? '2'
    end

    def discord_url
      "https://discord.com/api/webhooks/#{@discord_channel}/#{@discord_token}"
    end
  end
end
