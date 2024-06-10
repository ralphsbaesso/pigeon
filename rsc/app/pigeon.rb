# frozen_string_literal: true

module App
  class Pigeon
    def initialize(**options)
      @options = options.transform_keys(&:to_sym)
    end

    def deliver
      raise NotImplementedError
    end

    private

    def pigeon_name
      App.underscore(self.class.name.gsub('App::', ''))
    end

    def read_template(template_name)
      File.read(File.join(App.root, 'templates', pigeon_name, template_name))
    end

    def render(content)
      Linker.new(content, **@options).render
    end

    def validate_fields(*keys)
      errors = []
      keys.each do |key|
        next if present?(@options[key.to_sym])

        errors << "Must pass the value in key '#{key}´"
      end

      raise errors.join("\n") if errors.any?
    end

    def present?(value)
      if value.is_a?(String)
        !value.strip.empty?
      else
        value
      end
    end

    def remove_sensitive_data!(*keys)
      keys.each { |key| @options.delete(key.to_sym) }
    end
  end
end
