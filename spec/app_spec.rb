# frozen_string_literal: true

require 'spec_helper'

RSpec.describe App do
  describe 'call' do
    describe 'Discord' do
      it 'must send message to Discord channel', :vcr do
        args = {
          project_name: 'PigeonApp',
          env: 'undefined',
          'DISCORD_CHANNEL' => 'discord_channel',
          'DISCORD_TOKEN' => 'discord_token',
          'action' => 'start_sync'
        }

        result = App.call(:discord, **args)
        expect(result).to eq(true)
      end
    end
  end
end
