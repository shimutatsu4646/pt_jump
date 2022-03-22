require 'rails_helper'

RSpec.describe "Trainers Request", type: :request do
  describe "GET /trainers/show/:id" do
    let(:trainer) { create(:trainer) }

    context "URLのidに一致するトレーナーが存在する場合" do
      it "正常にレスポンスを返すこと" do
        get "/trainers/show/#{trainer.id}"
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status "200"
        end
      end
    end

    context "URLのidに一致するトレーナーが存在しない場合"
    it "404レスポンスを返すこと" do
      get "/trainers/show/#{trainer.id + 1}"
      expect(response).to have_http_status(404)
    end
  end
end
