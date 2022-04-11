require 'rails_helper'

RSpec.describe "Chats Request", type: :request do
  describe "GET /chats" do # index
    context "トレーニーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }

      it "正常にレスポンスを返すこと" do
        sign_in trainee
        get chats_path
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status "200"
        end
      end
    end

    context "トレーナーとしてログインしている場合" do
      let(:trainer) { create(:trainer) }

      it "正常にレスポンスを返すこと" do
        sign_in trainer
        get chats_path
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status "200"
        end
      end
    end

    context "ゲストユーザーの場合" do
      it "302レスポンスを返し、トップページにリダイレクトすること" do
        get chats_path
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe "GET /chats/:id" do # show
    context "トレーニーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }
      let(:trainer) { create(:trainer) }

      it "urlのidがトレーナーのidと一致するとき正常にレスポンスを返すこと" do
        sign_in trainee
        get "/chats/#{trainer.id}"
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status "200"
        end
      end

      it "urlのidがトレーナーのidと一致しないとき404レスポンスを返すこと" do
        sign_in trainee
        get "/chats/#{trainer.id + 1}"
        expect(response).to have_http_status(404)
      end
    end

    context "トレーナーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }
      let(:trainer) { create(:trainer) }

      context "urlのidがトレー二ーのidと一致しないとき" do
        it "404レスポンスを返すこと" do
          sign_in trainer
          get "/chats/#{trainee.id + 1}"
          expect(response).to have_http_status(404)
        end
      end

      context "urlのidがトレーニーのidと一致する場合" do
        context "traineeのchat_acceptanceがtrueの場合" do
          let(:accepting_trainee) { create(:trainee, chat_acceptance: true) }

          it "urlのidがトレー二ーのidと一致するとき正常にレスポンスを返すこと" do
            sign_in trainer
            get "/chats/#{accepting_trainee.id}"
            aggregate_failures do
              expect(response).to be_successful
              expect(response).to have_http_status "200"
            end
          end
        end

        context "traineeのchat_acceptanceがfalseの場合" do
          let(:rejecting_trainee) { create(:trainee, chat_acceptance: false) }

          context "このトレーニーとのチャット履歴・契約履歴がない場合" do
            it "302レスポンスを返し、トレーニー詳細ページにリダイレクトすること" do
              sign_in trainer
              get "/chats/#{rejecting_trainee.id}"
              aggregate_failures do
                expect(response).to have_http_status "302"
                expect(response).to redirect_to trainee_path(rejecting_trainee.id)
              end
            end
          end

          context "このトレーニーとのチャット履歴がある場合" do
            let!(:chat) do
              create(:chat,
                trainee_id: rejecting_trainee.id, trainer_id: trainer.id,
                content: "hello.", from_trainee: true)
            end

            it "正常にレスポンスを返すこと" do
              sign_in trainer
              get "/chats/#{rejecting_trainee.id}"
              aggregate_failures do
                expect(response).to be_successful
                expect(response).to have_http_status "200"
              end
            end
          end

          context "このトレーニーとの契約履歴がある場合" do
            let!(:contract) do
              create(:contract,
                trainee_id: rejecting_trainee.id, trainer_id: trainer.id,
                final_decision: false)
            end

            it "正常にレスポンスを返すこと" do
              sign_in trainer
              get "/chats/#{rejecting_trainee.id}"
              aggregate_failures do
                expect(response).to be_successful
                expect(response).to have_http_status "200"
              end
            end
          end
        end
      end
    end

    context "ゲストユーザーの場合" do
      let(:trainee) { create(:trainee) }
      let!(:trainer) { create(:trainer) }

      it "302レスポンスを返し、トップページにリダイレクトすること" do
        get "/chats/#{trainee.id}"
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end
