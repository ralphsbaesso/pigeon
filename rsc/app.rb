# frozen_string_literal: true

require_relative 'app/discord'
require_relative 'app/linker'

class App
  def initialize(channel)
    @resource = App.const_get "App::#{channel.split('_').map(&:capitalize).join}"
  end

  def call(**kwargs)
    resource = @resource.new(**kwargs)
    resource.deliver
  end

  def self.root
    File.join(Dir.pwd, 'rsc')
  end
end
