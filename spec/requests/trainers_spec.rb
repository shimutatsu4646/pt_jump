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

    context "URLのidに一致するトレーナーが存在しない場合" do
      it "404レスポンスを返すこと" do
        get "/trainers/show/#{trainer.id + 1}"
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "GET /trainers/edit_profile/:id" do
    let(:trainer) { create(:trainer) }

    context "認可されたトレーナーの場合" do
      it "正常にレスポンスを返すこと" do
        sign_in trainer
        get edit_profile_trainer_path(trainer)
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status "200"
        end
      end
    end

    context "認可されていない他ユーザーの場合" do
      let(:other_trainer) { create(:trainer) }

      it "302レスポンスを返し、自分の詳細ページにリダイレクトすること" do
        sign_in other_trainer
        get edit_profile_trainer_path(trainer)
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to trainer_path(other_trainer)
        end
      end
    end

    context "ゲストユーザーの場合" do
      it "302レスポンスを返し、トップページにリダイレクトすること" do
        # ログインしていない
        get edit_profile_trainer_path(trainer)
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe "PUT /trainers/update_profile/:id" do
    context "認可されたトレーナーの場合" do
      let(:trainer) { create(:trainer) }

      it "プロフィールを更新し、詳細ページにリダイレクトすること" do
        trainer_update_params = {
          name: "update_name",
          introduction: "hello",
          category: "building_muscle",
          instruction_method: "online",
          min_fee: 3000,
          instruction_period: "below_one_month",
          city_ids: ["517", "1707"],
          day_of_week_ids: ["6", "7"]
        }
        sign_in trainer
        put update_profile_trainer_path(trainer), params: { id: trainer.id, trainer: trainer_update_params }
        aggregate_failures do
          expect(trainer.reload.name).to eq "update_name"
          expect(trainer.reload.introduction).to eq "hello"
          expect(trainer.reload.category).to eq "building_muscle"
          expect(trainer.reload.instruction_method).to eq "online"
          expect(trainer.reload.min_fee).to eq 3000
          expect(trainer.reload.instruction_period).to eq "below_one_month"
          expect(trainer.cities.first.name).to eq "さいたま市"
          expect(trainer.cities.second.name).to eq "那覇市"
          expect(trainer.day_of_weeks.first.name).to eq "土曜日"
          expect(trainer.day_of_weeks.second.name).to eq "日曜日"
          expect(response).to redirect_to trainer_path(trainer.id)
        end
      end
    end

    context "認可されていないトレーナーの場合" do
      let(:trainer) { create(:trainer, name: "befoler_update_name") }
      let(:other_trainer) { create(:trainer) }

      it "対象のトレーナーを更新できず、自分の詳細ページにリダイレクトされること" do
        trainer_update_params = {
          name: "update_name"
        }
        sign_in other_trainer
        put update_profile_trainer_path(trainer), params: { id: trainer.id, trainer: trainer_update_params }
        aggregate_failures do
          expect(trainer.reload.name).to eq "befoler_update_name"
          expect(response).to redirect_to trainer_path(other_trainer.id)
        end
      end
    end

    context "ゲストユーザーの場合" do
      let(:trainer) { create(:trainer, name: "befoler_update_name") }

      it "対象のトレーナーを更新できず、トップページにリダイレクトすること" do
        trainer_update_params = {
          name: "update_name"
        }
        put update_profile_trainer_path(trainer), params: { id: trainer.id, trainer: trainer_update_params }
        aggregate_failures do
          expect(trainer.reload.name).to eq "befoler_update_name"
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe "GET /trainers/search" do
    context "ログイン済みトレーニーの場合" do
      let(:trainee) { create(:trainee) }

      context "@trainer_search_paramsがnilの場合" do
        it "正常にレスポンスを返すこと" do
          sign_in trainee
          get search_for_trainer_path
          aggregate_failures do
            expect(response).to be_successful
            expect(response).to have_http_status "200"
          end
        end
      end

      context "@trainer_search_paramsがnilでない場合" do
        it "正常にレスポンスを返すこと" do
          trainer_search_params = {
            age_from: nil,
            age_to: nil,
            gender: nil,
            chat_acceptance: false,
            category: nil,
            min_fee: nil,
            instruction_method: nil,
            instruction_period: nil,
            city_ids: [],
            day_of_week_ids: []
          }
          sign_in trainee
          get search_for_trainer_path, params: { search_trainer: trainer_search_params }
          aggregate_failures do
            expect(response).to be_successful
            expect(response).to have_http_status "200"
          end
        end
      end
    end

    context "ログイン済みトレーナーの場合" do
      let(:trainer) { create(:trainer) }

      it "302レスポンスを返し、トップページにリダイレクトすること" do
        sign_in trainer
        get search_for_trainer_path
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to root_path
        end
      end
    end

    context "ゲストユーザーの場合" do
      it "302レスポンスを返し、トレーニー用ログインページにリダイレクトすること" do
        get search_for_trainer_path
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to new_trainee_session_path
        end
      end
    end
  end
end
