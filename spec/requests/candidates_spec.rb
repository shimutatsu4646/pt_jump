require 'rails_helper'

RSpec.describe "Candidates Request", type: :request do
  describe "GET /candidates" do # index
    context "トレーニーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }

      it "正常にレスポンスを返すこと" do
        sign_in trainee
        get candidates_path
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status "200"
        end
      end
    end

    context "トレーナーとしてログインしている場合" do
      let(:trainer) { create(:trainer) }

      it "302レスポンスを返し、トレーニーログインページにリダイレクトすること" do
        sign_in trainer
        get candidates_path
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to new_trainee_session_path
        end
      end
    end

    context "ゲストユーザーの場合" do
      it "302レスポンスを返し、トップページにリダイレクトすること" do
        get candidates_path
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to new_trainee_session_path
        end
      end
    end
  end

  describe "POST /candidates/:id" do # create
    describe "POST /candidates" do # create
      context "トレーニーとしてログインしている場合" do
        let(:trainee) { create(:trainee) }
        let(:trainer) { create(:trainer) }

        it "トレーナー候補を生成すること" do
          sign_in trainee
          create_candidate_params = {
            trainee_id: trainee.id,
            trainer_id: trainer.id
          }
          expect do
            post create_candidate_path(trainer.id), xhr: true, params: { candidate: create_candidate_params }
          end.to change { Candidate.count }.by(1)
          expect(response).to have_http_status "200"
        end
      end

      context "トレーナーとしてログインしている場合" do
        let(:trainee) { create(:trainee) }
        let(:trainer) { create(:trainer) }

        it "トレーナー候補は生成されず、401レスポンスを返すこと" do
          sign_in trainer
          create_candidate_params = {
            trainee_id: trainee.id,
            trainer_id: trainer.id
          }
          expect do
            post create_candidate_path(trainer.id), xhr: true, params: { candidate: create_candidate_params }
          end.not_to change { Candidate.count }
          expect(response).to have_http_status "401"
        end
      end

      context "ゲストユーザーの場合" do
        let!(:trainee) { create(:trainee) }
        let!(:trainer) { create(:trainer) }

        it "トレーナー候補は生成されず、401レスポンスを返すこと" do
          create_candidate_params = {
            trainee_id: trainee.id,
            trainer_id: trainer.id
          }
          expect do
            post create_candidate_path(trainer.id), xhr: true, params: { candidate: create_candidate_params }
          end.not_to change { Candidate.count }
          expect(response).to have_http_status "401"
        end
      end
    end
  end

  describe "DELETE /candidates/:id" do # destory
    context "トレーニーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }
      let(:trainer) { create(:trainer) }

      let!(:candidate) do
        create(:candidate, trainee_id: trainee.id, trainer_id: trainer.id)
      end

      it "トレーナー候補データが削除されること" do
        sign_in trainee
        expect do
          delete destroy_candidate_path(trainer.id), xhr: true
        end.to change { Candidate.count }.by(-1)
        expect(response).to have_http_status "200"
      end
    end

    context "トレーナーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }
      let(:trainer) { create(:trainer) }

      let!(:candidate) do
        create(:candidate, trainee_id: trainee.id, trainer_id: trainer.id)
      end

      it "トレーナー候補データは削除されず、401レスポンスを返すこと" do
        sign_in trainer
        expect do
          delete destroy_candidate_path(trainer.id), xhr: true
        end.not_to change { Candidate.count }
        expect(response).to have_http_status "401"
      end
    end

    context "ゲストユーザーの場合" do
      let!(:trainee) { create(:trainee) }
      let!(:trainer) { create(:trainer) }

      let!(:candidate) do
        create(:candidate, trainee_id: trainee.id, trainer_id: trainer.id)
      end

      it "トレーナー候補データは削除されず、401レスポンスを返すこと" do
        expect do
          delete destroy_candidate_path(trainer.id), xhr: true
        end.not_to change { Candidate.count }
        expect(response).to have_http_status "401"
      end
    end
  end
end
