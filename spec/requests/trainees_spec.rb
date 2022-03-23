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

    context "URLのidに一致するトレーニーが存在しない場合" do
      it "404レスポンスを返すこと" do
        get "/trainees/show/#{trainee.id + 1}"
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "GET /trainees/edit_profile/:id" do
    let(:trainee) { create(:trainee) }

    context "認可されたトレーニーの場合" do
      it "正常にレスポンスを返すこと" do
        sign_in trainee
        get edit_profile_trainee_path(trainee)
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status "200"
        end
      end
    end

    context "認可されていない他ユーザーの場合" do
      let(:other_trainee) { create(:trainee) }

      it "302レスポンスを返し、自分の詳細ページにリダイレクトすること" do
        sign_in other_trainee
        get edit_profile_trainee_path(trainee)
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to trainee_path(other_trainee)
        end
      end
    end

    context "ゲストユーザーの場合" do
      it "302レスポンスを返し、トップページにリダイレクトすること" do
        # ログインしていない
        get edit_profile_trainee_path(trainee)
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe "PUT /trainees/update_profile/:id" do
    context "認可されたトレーニーの場合" do
      let(:trainee) { create(:trainee) }

      it "プロフィールを更新し、詳細ページにリダイレクトすること" do
        trainee_update_params = {
          name: "update_name",
          introduction: "hello",
          timeframe: "9:00~17:00",
          dm_allowed: true
        }
        sign_in trainee
        put update_profile_trainee_path(trainee), params: { id: trainee.id, trainee: trainee_update_params }
        aggregate_failures do
          expect(trainee.reload.name).to eq "update_name"
          expect(trainee.reload.introduction).to eq "hello"
          expect(trainee.reload.timeframe).to eq "9:00~17:00"
          expect(trainee.reload.dm_allowed).to eq true
          expect(response).to redirect_to trainee_path(trainee.id)
        end
      end
    end

    context "認可されていないトレーニーの場合" do
      let(:trainee) { create(:trainee, name: "befoler_update_name") }
      let(:other_trainee) { create(:trainee) }

      it "対象のトレーニーを更新できず、自分の詳細ページにリダイレクトされること" do
        trainee_update_params = {
          name: "update_name"
        }
        sign_in other_trainee
        put update_profile_trainee_path(trainee), params: { id: trainee.id, trainee: trainee_update_params }
        aggregate_failures do
          expect(trainee.reload.name).to eq "befoler_update_name"
          expect(response).to redirect_to trainee_path(other_trainee.id)
        end
      end
    end

    context "ゲストユーザーの場合" do
      let(:trainee) { create(:trainee, name: "befoler_update_name") }

      it "対象のトレーニーを更新できず、トップページにリダイレクトすること" do
        trainee_update_params = {
          name: "update_name"
        }
        put update_profile_trainee_path(trainee), params: { id: trainee.id, trainee: trainee_update_params }
        aggregate_failures do
          expect(trainee.reload.name).to eq "befoler_update_name"
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end
