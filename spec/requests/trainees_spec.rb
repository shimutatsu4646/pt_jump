require 'rails_helper'

RSpec.describe "Trainees", type: :request do
  describe "GET /trainees/show/:id" do
    let!(:trainee) { create(:trainee) }

    it "URLのidに一致するトレーニーのプロフィールページを開くこと" do
      get "/trainees/show/#{trainee.id}"
      expect(response).to have_http_status(:success)
    end

    it "URLのidに一致するトレーニーがいない場合、プロフィールページを開かないこと" do
      get "/trainees/show/#{trainee.id + 1}"
      expect(response).to have_http_status(404)
    end
  end
end
