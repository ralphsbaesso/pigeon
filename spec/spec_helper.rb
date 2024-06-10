# frozen_string_literal: true

require 'byebug'
require 'vcr'
require 'webmock'
require_relative '../rsc/app'

VCR.configure do |config|
  config.cassette_library_dir = File.join('spec', 'vrc_cassettes')
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.preserve_exact_body_bytes do |http_message|
    http_message.body.encoding.name == 'ASCII-8BIT' || !http_message.body.valid_encoding?
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.around(:each) do |example|
    if example.metadata.key?(:vcr)
      example.run
    else
      WebMock.allow_net_connect!
      VCR.turned_off { example.run }
      WebMock.disable_net_connect!
    end
  end
end
