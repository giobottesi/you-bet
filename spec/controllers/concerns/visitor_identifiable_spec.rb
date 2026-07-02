require 'rails_helper'

RSpec.describe VisitorIdentifiable, type: :controller do
  controller(ApplicationController) do
    def index
      render plain: current_visitor_id
    end
  end

  it 'issues a UUID visitor id' do
    get :index

    expect(response.body).to match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/)
  end

  it 'reuses the same visitor id across requests' do
    get :index
    first_visitor_id = response.body

    get :index

    expect(response.body).to eq(first_visitor_id)
  end
end
