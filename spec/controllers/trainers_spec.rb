require 'rails_helper'

RSpec.describe TrainersController, type: :controller do
  describe "#show" do
    context "URLのidに一致するトレーナーが存在する場合" do
      let(:trainer) { create(:trainer) }

      it "正常にレスポンスを返すこと" do
        get :show, params: { id: trainer.id }
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status "200"
        end
      end
    end
  end
end
