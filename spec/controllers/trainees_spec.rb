require 'rails_helper'

RSpec.describe TraineesController, type: :controller do
  describe "#show" do
    context "URLのidに一致するトレーニーが存在する場合" do
      let(:trainee) { create(:trainee) }

      it "正常にレスポンスを返すこと" do
        get :show, params: { id: trainee.id }
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status "200"
        end
      end
    end
  end
end
