require 'rails_helper'

RSpec.describe "Trainees Request", type: :request do
  describe "GET /trainees/show/:id" do
    let(:trainee) { create(:trainee) }

    context "URLのidに一致するトレーニーが存在する場合" do
      it "正常にレスポンスを返すこと" do
        get "/trainees/show/#{trainee.id}"
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status "200"
        end
      end
    end

    context "URLのidに一致するトレーニーが存在しない場合"
    it "404レスポンスを返すこと" do
      get "/trainees/show/#{trainee.id + 1}"
      expect(response).to have_http_status(404)
    end
  end
end
