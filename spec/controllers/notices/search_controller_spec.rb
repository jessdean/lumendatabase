require 'rails_helper'

describe Notices::SearchController do
  context "#index" do
    it "uses SearchesModels" do
      searcher = SearchesModels.new
      expect(SearchesModels).to receive(:new).and_return(searcher)

      get :index, { term: 'foo' }

      expect(response).to be_successful
    end
  end

  scenario 'deep pagination allowed with json', search: true do
    get :index, page: 100, term: 'batman', format: :json
    expect(response).to have_http_status :success
  end

  scenario 'deep pagination not allowed with html', search: true do
    get :index, page: 100, term: 'batman'
    expect(response).to have_http_status :unauthorized
  end

  scenario 'shallow pagination allowed with html', search: true do
    get :index, page: 10, term: 'batman'
    expect(response).to have_http_status :success
  end

  scenario 'deep pagination allowed for signed-in users', search: true do
    SearchController.any_instance.stub(:user_signed_in?).and_return(true)
    get :index, page: 100, term: 'batman'
    expect(response).to have_http_status :success
  end
end
