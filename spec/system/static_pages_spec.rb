require 'rails_helper'

RSpec.describe "StaticPages System", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "ヘッダー" do
    context "トレーニーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }

      before do
        login_as_trainee trainee
      end

      describe "リンク" do
        scenario "「トレーナー検索」をクリックするとトレーナー検索ページにリダイレクトすること" do
          visit root_path
          within(:css, "header") do
            click_on "トレーナー検索"
          end
          expect(current_path).to eq search_for_trainer_path
        end

        scenario "「トレーナー候補一覧」をクリックするとトレーナー候補一覧ページにリダイレクトすること" do
          visit root_path
          within(:css, "header") do
            click_on "トレーナー候補一覧"
          end
          expect(current_path).to eq candidates_path
        end

        scenario "「チャット一覧」をクリックするとチャット一覧ページにリダイレクトすること" do
          visit root_path
          within(:css, "header") do
            click_on "チャット一覧"
          end
          expect(current_path).to eq chats_path
        end

        scenario "「契約一覧」をクリックすると契約一覧ページにリダイレクトすること" do
          visit root_path
          within(:css, "header") do
            click_on "契約一覧"
          end
          expect(current_path).to eq contracts_path
        end

        scenario "「プロフィール」をクリックするとプロフィールページにリダイレクトすること" do
          visit root_path
          within(:css, "header") do
            click_on "プロフィール"
          end
          expect(current_path).to eq trainee_path(trainee.id)
        end

        scenario "「ログアウト」をクリックすると、ログアウトすること" do
          visit root_path
          within(:css, "header") do
            click_on "ログアウト"
          end
          aggregate_failures do
            expect(page).to have_content "ログアウトしました。"
            expect(current_path).to eq root_path
          end
        end
      end
    end

    context "トレーナーとしてログインしている場合" do
      let(:trainer) { create(:trainer) }

      before do
        login_as_trainer trainer
      end

      describe "リンク" do
        scenario "「トレーニー検索」をクリックするとトレーニー検索ページにリダイレクトすること" do
          visit root_path
          within(:css, "header") do
            click_on "トレーニー検索"
          end
          expect(current_path).to eq search_for_trainee_path
        end

        scenario "「チャット一覧」をクリックするとチャット一覧ページにリダイレクトすること" do
          visit root_path
          within(:css, "header") do
            click_on "チャット一覧"
          end
          expect(current_path).to eq chats_path
        end

        scenario "「契約一覧」をクリックすると契約一覧ページにリダイレクトすること" do
          visit root_path
          within(:css, "header") do
            click_on "契約一覧"
          end
          expect(current_path).to eq contracts_path
        end

        scenario "「プロフィール」をクリックするとプロフィールページにリダイレクトすること" do
          visit root_path
          within(:css, "header") do
            click_on "プロフィール"
          end
          expect(current_path).to eq trainer_path(trainer.id)
        end

        scenario "「ログアウト」をクリックすると、ログアウトすること" do
          visit root_path
          within(:css, "header") do
            click_on "ログアウト"
          end
          aggregate_failures do
            expect(page).to have_content "ログアウトしました。"
            expect(current_path).to eq root_path
          end
        end
      end
    end

    context "ゲストユーザーの場合" do
      describe "リンク" do
        scenario "「トレーニーログイン」をクリックするとトレーニーログインページにリダイレクトすること" do
          visit root_path
          within(:css, "header") do
            click_on "トレーニーログイン"
          end
          expect(current_path).to eq new_trainee_session_path
        end

        scenario "「トレーニー登録」をクリックするとトレーニー新規登録ページにリダイレクトすること" do
          visit root_path
          within(:css, "header") do
            click_on "トレーニー登録"
          end
          expect(current_path).to eq new_trainee_registration_path
        end

        scenario "「トレーナーログイン」をクリックするとトレーナーログインページにリダイレクトすること" do
          visit root_path
          within(:css, "header") do
            click_on "トレーナーログイン"
          end
          expect(current_path).to eq new_trainer_session_path
        end

        scenario "「トレーナー登録」をクリックするとトレーナー新規登録ページにリダイレクトすること" do
          visit root_path
          within(:css, "header") do
            click_on "トレーナー登録"
          end
          expect(current_path).to eq new_trainer_registration_path
        end
      end
    end
  end

  describe "トップページ" do
    context "トレーニーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }

      before do
        login_as_trainee trainee
      end

      describe "リンク" do
        scenario "「トレーナー検索」をクリックするとトレーナー検索ページにリダイレクトすること" do
          visit root_path
          within(:css, "main") do
            click_on "トレーナー検索"
          end
          expect(current_path).to eq search_for_trainer_path
        end

        scenario "「トレーナー候補の一覧」をクリックするとトレーナー候補一覧ページにリダイレクトすること" do
          visit root_path
          within(:css, "main") do
            click_on "トレーナー候補の一覧"
          end
          expect(current_path).to eq candidates_path
        end

        scenario "「チャットの一覧」をクリックするとチャット一覧ページにリダイレクトすること" do
          visit root_path
          within(:css, "main") do
            click_on "チャットの一覧"
          end
          expect(current_path).to eq chats_path
        end

        scenario "「契約の一覧」をクリックすると契約一覧ページにリダイレクトすること" do
          visit root_path
          within(:css, "main") do
            click_on "契約の一覧"
          end
          expect(current_path).to eq contracts_path
        end

        scenario "「プロフィールページ」をクリックするとプロフィールページにリダイレクトすること" do
          visit root_path
          within(:css, "main") do
            click_on "プロフィールページ"
          end
          expect(current_path).to eq trainee_path(trainee.id)
        end

        scenario "「プロフィール変更ページ」をクリックするとプロフィール変更ページにリダイレクトすること" do
          visit root_path
          within(:css, "main") do
            click_on "プロフィール変更ページ"
          end
          expect(current_path).to eq edit_profile_trainee_path(trainee.id)
        end

        scenario "「アカウント情報変更ページ」をクリックするとアカウント情報変更ページにリダイレクトすること" do
          visit root_path
          within(:css, "main") do
            click_on "アカウント情報変更ページ"
          end
          expect(current_path).to eq edit_trainee_registration_path(trainee.id)
        end

        scenario "「ログアウト」をクリックすると、ログアウトすること" do
          visit root_path
          within(:css, "main") do
            click_on "ログアウト"
          end
          aggregate_failures do
            expect(page).to have_content "ログアウトしました。"
            expect(current_path).to eq root_path
          end
        end
      end
    end

    context "トレーナーとしてログインしている場合" do
      let(:trainer) { create(:trainer) }

      before do
        login_as_trainer trainer
      end

      describe "リンク" do
        scenario "「トレーニー検索」をクリックするとトレーニー検索ページにリダイレクトすること" do
          visit root_path
          within(:css, "main") do
            click_on "トレーニー検索"
          end
          expect(current_path).to eq search_for_trainee_path
        end

        scenario "「チャットの一覧」をクリックするとチャット一覧ページにリダイレクトすること" do
          visit root_path
          within(:css, "main") do
            click_on "チャットの一覧"
          end
          expect(current_path).to eq chats_path
        end

        scenario "「契約の一覧」をクリックすると契約一覧ページにリダイレクトすること" do
          visit root_path
          within(:css, "main") do
            click_on "契約の一覧"
          end
          expect(current_path).to eq contracts_path
        end

        scenario "「プロフィールページ」をクリックするとプロフィールページにリダイレクトすること" do
          visit root_path
          within(:css, "main") do
            click_on "プロフィールページ"
          end
          expect(current_path).to eq trainer_path(trainer.id)
        end

        scenario "「プロフィール変更ページ」をクリックするとプロフィール変更ページにリダイレクトすること" do
          visit root_path
          within(:css, "main") do
            click_on "プロフィール変更ページ"
          end
          expect(current_path).to eq edit_profile_trainer_path(trainer.id)
        end

        scenario "「アカウント情報変更ページ」をクリックするとアカウント情報変更ページにリダイレクトすること" do
          visit root_path
          within(:css, "main") do
            click_on "アカウント情報変更ページ"
          end
          expect(current_path).to eq edit_trainer_registration_path(trainer.id)
        end

        scenario "「ログアウト」をクリックすると、ログアウトすること" do
          visit root_path
          within(:css, "main") do
            click_on "ログアウト"
          end
          aggregate_failures do
            expect(page).to have_content "ログアウトしました。"
            expect(current_path).to eq root_path
          end
        end
      end
    end

    context "ゲストユーザーの場合" do
      describe "リンク" do
        scenario "「トレーニーとしてログイン」をクリックするとトレーニーログインページにリダイレクトすること" do
          visit root_path
          within(:css, "main") do
            click_on "トレーニーとしてログイン"
          end
          expect(current_path).to eq new_trainee_session_path
        end

        scenario "「トレーニーとして新規登録」をクリックするとトレーニー新規登録ページにリダイレクトすること" do
          visit root_path
          within(:css, "main") do
            click_on "トレーニーとして新規登録"
          end
          expect(current_path).to eq new_trainee_registration_path
        end

        scenario "「トレーナーとしてログイン」をクリックするとトレーナーログインページにリダイレクトすること" do
          visit root_path
          within(:css, "main") do
            click_on "トレーナーとしてログイン"
          end
          expect(current_path).to eq new_trainer_session_path
        end

        scenario "「トレーナーとして新規登録」をクリックするとトレーナー新規登録ページにリダイレクトすること" do
          visit root_path
          within(:css, "main") do
            click_on "トレーナーとして新規登録"
          end
          expect(current_path).to eq new_trainer_registration_path
        end
      end
    end
  end
end
