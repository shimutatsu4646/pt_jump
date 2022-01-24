require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /" do
    it "トップページが開くこと" do
      get "/"
      expect(response).to have_http_status(:success)
    end
  end
end
