# frozen_string_literal: true

require 'spec_helper'

RSpec.describe App::Discord do
  describe 'instance methods' do
    describe '#create_template' do
      let(:env) { %w[production staging development].sample }
      let(:project_name) { %w[MyPages MyMoney MyDebts].sample }

      it 'must return start_sync template' do
        action = 'start_sync'
        discord = App::Discord.new(project_name:, env:, action:)
        template = discord.send(:create_template)
        expect(template).to eq("Inicializado atualização do **#{project_name}** no ambiente **#{env}**\nAtualização via **ArgoCD**")
      end

      it 'must return finished_sync template' do
        action = 'finished_sync'
        discord = App::Discord.new(project_name:, env:, action:)
        template = discord.send(:create_template)
        expect(template).to eq("Finalizado atualização do **#{project_name}** no ambiente **#{env}**\nAtualização via **ArgoCD**")
      end

      it 'must return finished_sync template' do
        action = %w[any all another].sample
        discord = App::Discord.new(project_name:, env:, action:)
        template = discord.send(:create_template)
        expect(template).to eq("Template #{action} não disponível")
      end
    end
  end
end
