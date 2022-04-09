require 'rails_helper'

RSpec.describe "Chats Request", type: :request do
  describe "GET /chats" do # index
    let(:trainee) { create(:trainee) }
    let(:trainer) { create(:trainer) }

    context "トレーニーとしてログインしている場合" do
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

      it "urlのidがトレー二ーのidと一致するとき正常にレスポンスを返すこと" do
        sign_in trainer
        get "/chats/#{trainee.id}"
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status "200"
        end
      end

      it "urlのidがトレー二ーのidと一致しないとき404レスポンスを返すこと" do
        sign_in trainer
        get "/chats/#{trainee.id + 1}"
        expect(response).to have_http_status(404)
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
