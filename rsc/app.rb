# frozen_string_literal: true

require_relative 'app/pigeon'
require_relative 'app/linker'
require_relative 'app/discord'

module App
  class << self
    def call(channel_name, **kwargs)
      resource = App.const_get("App::#{App.camelize(channel_name)}")
      pigeon = resource.new(**kwargs.transform_keys(&:downcase))
      pigeon.deliver
      true
    end

    def root
      File.join(Dir.pwd, 'rsc')
    end

    def underscore(str)
      str.to_s
         .gsub(/::/, '/')
         .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
         .gsub(/([a-z\d])([A-Z])/, '\1_\2')
         .tr('-', '_')
         .downcase
    end

    def camelize(str)
      str.to_s.split('_').map(&:capitalize).join
    end
  end
end
