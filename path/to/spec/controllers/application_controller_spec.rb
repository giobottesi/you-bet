# spec/controllers/application_controller_spec.rb

require 'rails_helper'

RSpec.describe ApplicationController do
  describe '#translate' do
    it 'returns the translated text' do
      expect(ApplicationHelper.translate(:hello)).to eq('Hello')
      expect(ApplicationHelper.translate(:hello)).to eq('Olá')
    end
  end
end