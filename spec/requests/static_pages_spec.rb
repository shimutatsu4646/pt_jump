require 'rails_helper'

RSpec.describe "StaticPages Request", type: :request do
  describe "GET /" do
    it "正常にレスポンスを返すこと" do
      get "/"
      aggregate_failures do
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end
  end
end
