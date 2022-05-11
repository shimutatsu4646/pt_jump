require 'rails_helper'

RSpec.describe "Reviews Request", type: :request do
  describe "GET /index/:id" do # index
    context "トレーニーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }
      let(:trainer) { create(:trainer) }

      it "正常にレスポンスを返すこと" do
        sign_in trainee
        get index_reviews_path(trainer.id)
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status "200"
        end
      end
    end

    context "トレーナーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }
      let(:trainer) { create(:trainer) }

      it "正常にレスポンスを返すこと" do
        sign_in trainer
        get index_reviews_path(trainer.id)
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status "200"
        end
      end
    end

    context "ゲストユーザーの場合" do
      let(:trainer) { create(:trainer) }

      it "302レスポンスを返し、対象のトレーナー詳細ページにリダイレクトすること" do
        get index_reviews_path(trainer.id)
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to trainer_path(trainer.id)
        end
      end
    end
  end

  describe "GET /new/:id" do # new
    context "トレーニーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }
      let(:trainer) { create(:trainer) }

      context "成立済みの契約がある場合" do
        let!(:contract) do
          create(:contract, trainee_id: trainee.id, trainer_id: trainer.id, final_decision: true)
        end

        it "正常にレスポンスを返すこと" do
          sign_in trainee
          get new_review_path(trainer.id)
          aggregate_failures do
            expect(response).to be_successful
            expect(response).to have_http_status "200"
          end
        end
      end

      context "成立済みの契約がない場合" do
        let!(:contract) do
          create(:contract, trainee_id: trainee.id, trainer_id: trainer.id, final_decision: false)
          # final_decision: false => まだ成立していない
        end

        it "302レスポンスを返し、トレーナー詳細ページにリダイレクトされること" do
          sign_in trainee
          get new_review_path(trainer.id)
          aggregate_failures do
            expect(response).to have_http_status "302"
            expect(response).to redirect_to trainer_path(trainer.id)
          end
        end
      end
    end

    context "トレーナーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }
      let(:trainer) { create(:trainer) }

      it "302レスポンスを返し、トレーニーログインページにリダイレクトすること" do
        sign_in trainer
        get new_review_path(trainer.id)
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to new_trainee_session_path
        end
      end
    end

    context "ゲストユーザーの場合" do
      let!(:trainee) { create(:trainee) }
      let!(:trainer) { create(:trainer) }

      it "302レスポンスを返し、トレーニーログインページにリダイレクトすること" do
        get new_review_path(trainer.id)
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to new_trainee_session_path
        end
      end
    end
  end

  describe "POST /reviews" do # create
    context "トレーニーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }
      let(:trainer) { create(:trainer) }

      context "成立済みの契約がある場合" do
        let!(:contract) do
          create(:contract, trainee_id: trainee.id, trainer_id: trainer.id, final_decision: true)
        end

        it "入力値に問題がない場合、レビューを生成し、トレーナー詳細ページにリダイレクトすること" do
          sign_in trainee
          create_review_params = {
            trainer_id: trainer.id,
            title: "title",
            comment: "comment text",
            star_rate: 4.0
          }
          expect do
            post reviews_path, params: { id: trainer.id, review: create_review_params }
          end.to change { Review.count }.by(1)
          expect(response).to redirect_to trainer_path(trainer.id)
        end

        context "成立済みの契約がない場合" do
          let!(:contract) do
            create(:contract, trainee_id: trainee.id, trainer_id: trainer.id, final_decision: false)
          end

          it "入力値に問題がない場合であっても、レビューは生成されず、トレーナー詳細ページにリダイレクトすること" do
            sign_in trainee
            create_review_params = {
              trainer_id: trainer.id,
              title: "title",
              comment: "comment text",
              star_rate: 5.0
            }
            expect do
              post reviews_path, params: { id: trainer.id, review: create_review_params }
            end.not_to change { Review.count }

            expect(response).to redirect_to trainer_path(trainer.id)
          end
        end
      end

      context "成立済みの契約がある場合" do
        let!(:contract) do
          create(:contract, trainee_id: trainee.id, trainer_id: trainer.id, final_decision: true)
        end

        it "入力値に問題がある場合、契約は生成されず、レビュー投稿ページ（#new）にレンダリングされること" do
          sign_in trainee
          create_review_params = {
            trainer_id: trainer.id,
            title: nil,
            comment: "",
            star_rate: 6.0,
          }
          expect do
            post reviews_path, params: { id: trainer.id, review: create_review_params }
          end.not_to change { Review.count }

          expect(response).to render_template("new")
        end
      end
    end

    context "トレーナーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }
      let(:trainer) { create(:trainer) }

      it "レビューは生成されず、302レスポンスを返し、トレーニーログインページにリダイレクトすること" do
        sign_in trainer
        create_review_params = {
          trainer_id: trainer.id,
          title: "title",
          comment: "comment text",
          star_rate: 5.0
        }
        expect do
          post reviews_path, params: { id: trainee.id, review: create_review_params }
        end.not_to change { Review.count }
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to new_trainee_session_path
        end
      end
    end

    context "ゲストユーザーの場合" do
      let!(:trainee) { create(:trainee) }
      let!(:trainer) { create(:trainer) }

      it "レビューは生成されず、302レスポンスを返し、トレーニーログインページにリダイレクトすること" do
        create_review_params = {
          trainer_id: trainer.id,
          title: "title",
          comment: "comment text",
          star_rate: 5.0
        }
        expect do
          post reviews_path, params: { review: create_review_params }
        end.not_to change { Review.count }
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to new_trainee_session_path
        end
      end
    end
  end

  describe "GET /reviews/:id/edit" do # edit
    context "トレーニーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }
      let(:trainer) { create(:trainer) }
      let(:review) do
        create(:review, trainee_id: trainee.id, trainer_id: trainer.id)
      end

      it "正常にレスポンスを返すこと" do
        sign_in trainee
        get edit_review_path(review.id)
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status "200"
        end
      end
    end

    context "トレーナーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }
      let(:trainer) { create(:trainer) }
      let(:review) do
        create(:review, trainee_id: trainee.id, trainer_id: trainer.id)
      end

      it "302レスポンスを返し、トレーニーログインページにリダイレクトすること" do
        sign_in trainer
        get edit_review_path(review.id)
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to new_trainee_session_path
        end
      end
    end

    context "ゲストユーザーの場合" do
      let!(:trainee) { create(:trainee) }
      let!(:trainer) { create(:trainer) }
      let(:review) do
        create(:review, trainee_id: trainee.id, trainer_id: trainer.id)
      end

      it "302レスポンスを返し、トレーニーログインページにリダイレクトすること" do
        get edit_review_path(review.id)
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to new_trainee_session_path
        end
      end
    end
  end

  describe "PATCH reviews/:id" do # update
    context "トレーニーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }
      let(:trainer) { create(:trainer) }
      let(:review) do
        create(:review, trainee_id: trainee.id, trainer_id: trainer.id)
      end

      before do
        sign_in trainee
      end

      context "入力値が問題ない場合" do
        it "レビューは更新され、トレーナーログインページにリダイレクトすること" do
          aggregate_failures do
            expect(review.title).to eq "title"
            expect(review.comment).to eq "comment text"
            expect(review.star_rate).to eq 5.0
          end

          update_review_params = {
            title: "updated title",
            comment: "updated comment text",
            star_rate: 4.0
          }

          patch review_path(review.id), params: { id: review.id, review: update_review_params }
          aggregate_failures do
            expect(review.reload.title).to eq "updated title"
            expect(review.reload.comment).to eq "updated comment text"
            expect(review.reload.star_rate).to eq 4.0
            expect(response).to redirect_to trainer_path(trainer.id)
          end
        end
      end

      context "入力値に問題がある場合" do
        it "レビューは更新されず、レビュー編集ページにレンダリングすること" do
          aggregate_failures do
            expect(review.title).to eq "title"
            expect(review.comment).to eq "comment text"
            expect(review.star_rate).to eq 5.0
          end

          update_review_params = {
            title: nil,
            comment: nil,
            star_rate: nil
          }

          patch review_path(review.id), params: { id: review.id, review: update_review_params }
          aggregate_failures do
            expect(review.reload.title).to eq "title"
            expect(review.reload.comment).to eq "comment text"
            expect(review.reload.star_rate).to eq 5.0
            expect(response).to render_template "edit"
          end
        end
      end
    end

    context "トレーナーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }
      let(:trainer) { create(:trainer) }
      let(:review) do
        create(:review, trainee_id: trainee.id, trainer_id: trainer.id)
      end

      before do
        sign_in trainer
      end

      it "レビューは更新されず、トレーニーログインページにリダイレクトすること" do
        aggregate_failures do
          expect(review.title).to eq "title"
          expect(review.comment).to eq "comment text"
          expect(review.star_rate).to eq 5.0
        end

        update_review_params = {
          title: nil,
          comment: nil,
          star_rate: nil
        }

        patch review_path(review.id), params: { id: review.id, review: update_review_params }
        aggregate_failures do
          expect(review.reload.title).to eq "title"
          expect(review.reload.comment).to eq "comment text"
          expect(review.reload.star_rate).to eq 5.0
          expect(response).to redirect_to new_trainee_session_path
        end
      end
    end

    context "ゲストユーザーの場合" do
      let!(:trainee) { create(:trainee) }
      let!(:trainer) { create(:trainer) }
      let(:review) do
        create(:review, trainee_id: trainee.id, trainer_id: trainer.id)
      end

      it "レビューは更新されず、トレーニーログインページにリダイレクトすること" do
        aggregate_failures do
          expect(review.title).to eq "title"
          expect(review.comment).to eq "comment text"
          expect(review.star_rate).to eq 5.0
        end

        update_review_params = {
          title: nil,
          comment: nil,
          star_rate: nil
        }

        patch review_path(review.id), params: { id: review.id, review: update_review_params }
        aggregate_failures do
          expect(review.reload.title).to eq "title"
          expect(review.reload.comment).to eq "comment text"
          expect(review.reload.star_rate).to eq 5.0
          expect(response).to redirect_to new_trainee_session_path
        end
      end
    end
  end
end
