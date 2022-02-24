require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  describe "#top" do
    it "正常にレスポンスを返すこと" do
      get :top
      aggregate_failures do
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end
  end
end
