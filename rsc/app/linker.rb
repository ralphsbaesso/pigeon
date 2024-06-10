# frozen_string_literal: true

require 'erb'

module App
  class Linker
    def initialize(content, **attributes)
      @__content = content
      attributes.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def render
      ERB.new(@__content).result(binding)
    end
  end
end
