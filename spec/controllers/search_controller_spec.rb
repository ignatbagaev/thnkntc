require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe "GET #index" do
    it 'calls #find on Search model' do
      expect(Search).to receive(:find).with('query', 'object')
      get :index, query: 'query', object: 'object'
    end
    it 'renders index template' do
      get :index
      expect(response).to render_template 'index'
    end
    it 'returns status 200' do
      get :index
      expect(response.status).to eq 200
    end
  end

end
