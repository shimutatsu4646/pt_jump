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
          category: "building_muscle",
          instruction_method: "online",
          chat_acceptance: true,
          city_ids: ["1", "634"],
          day_of_week_ids: ["1", "2"]
        }
        sign_in trainee
        put update_profile_trainee_path(trainee), params: { id: trainee.id, trainee: trainee_update_params }
        aggregate_failures do
          expect(trainee.reload.name).to eq "update_name"
          expect(trainee.reload.introduction).to eq "hello"
          expect(trainee.reload.category).to eq "building_muscle"
          expect(trainee.reload.instruction_method).to eq "online"
          expect(trainee.reload.chat_acceptance).to eq true
          expect(trainee.cities.first.name).to eq "札幌市"
          expect(trainee.cities.second.name).to eq "千代田区"
          expect(trainee.day_of_weeks.first.name).to eq "月曜日"
          expect(trainee.day_of_weeks.second.name).to eq "火曜日"
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

  describe "GET /trainees/search" do
    context "ログイン済みトレーナーの場合" do
      let(:trainer) { create(:trainer) }

      context "@trainee_search_paramsがnilの場合" do
        it "正常にレスポンスを返すこと" do
          sign_in trainer
          get search_for_trainee_path
          aggregate_failures do
            expect(response).to be_successful
            expect(response).to have_http_status "200"
          end
        end
      end

      context "@trainee_search_paramsがnilでない場合" do
        it "正常にレスポンスを返すこと" do
          trainee_search_params = {
            age_from: nil,
            age_to: nil,
            gender: nil,
            chat_acceptance: false,
            category: nil,
            instruction_method: nil,
            city_ids: [],
            day_of_week_ids: [],
          }
          sign_in trainer
          get search_for_trainee_path, params: { search_trainee: trainee_search_params }
          aggregate_failures do
            expect(response).to be_successful
            expect(response).to have_http_status "200"
          end
        end
      end
    end

    context "ログイン済みトレーニーの場合" do
      let(:trainee) { create(:trainee) }

      it "302レスポンスを返し、トップページにリダイレクトすること" do
        sign_in trainee
        get search_for_trainee_path
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to root_path
        end
      end
    end

    context "ゲストユーザーの場合" do
      it "302レスポンスを返し、トレーナー用ログインページにリダイレクトすること" do
        get search_for_trainee_path
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to new_trainer_session_path
        end
      end
    end
  end
end
