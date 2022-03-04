require 'rails_helper'

RSpec.describe "Trainees System", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "詳細ページ" do
    let(:trainee) { create(:trainee) }

    context "対象のトレーニーがログインユーザーの場合" do
      scenario "詳細ページに「プロフィール変更」リンクが表示されていること" do
        login trainee
        visit trainee_path(trainee.id)
        expect(page).to have_content "プロフィール変更"
      end
    end

    context "対象のトレーニーがログインユーザーではない場合" do
      let(:other_trainee) { create(:trainee, name: "other_trainee_name", email: "other_trainee@example.com") }

      scenario "詳細ページに「プロフィール変更」リンクが表示されていないこと" do
        login other_trainee
        visit trainee_path(trainee.id)
        expect(page).not_to have_content "プロフィール変更"
      end
    end
  end

  describe "Registration" do
    describe "トレーニーの新規登録" do
      context "入力値に問題がない場合" do
        scenario "新規登録すること" do
          visit new_trainee_registration_path
          expect do
            fill_in "trainee_name", with: "test_trainee_name"
            fill_in "trainee_age", with: 20
            select "male", from: "trainee_gender"
            fill_in "trainee_email", with: "system_test1@example.com"
            fill_in "trainee_password", with: "test_password"
            fill_in "trainee_password_confirmation", with: "test_password"
            check "trainee_dm_allowed"
            click_button "登録"

            trainee = Trainee.find_by(name: "test_trainee_name")
            aggregate_failures do
              expect(current_path).to eq trainee_path(trainee.id)
              expect(page).to have_content "アカウント登録が完了しました。"
            end
          end.to change { Trainee.count }.by(1)
        end
      end

      context "入力値に問題がある場合" do
        scenario "新規登録できないこと" do
          visit new_trainee_registration_path
          expect do
            # nameとageがnilのため、エラー発生
            fill_in "trainee_name", with: nil
            fill_in "trainee_age", with: nil
            select "male", from: "trainee_gender"
            fill_in "trainee_email", with: "system_test2@example.com"
            fill_in "trainee_password", with: "test_password"
            fill_in "trainee_password_confirmation", with: "test_password"
            check "trainee_dm_allowed"
            click_button "登録"

            aggregate_failures do
              expect(page).to have_content "名前を入力してください"
              expect(page).to have_content "年齢を入力してください"
            end
          end.to change { Trainee.count }.by(0)
        end
      end
    end

    describe "トレーニーの更新" do
      let(:trainee) { create(:trainee) }

      context "入力値に問題がない場合" do
        scenario "更新すること" do
          login trainee
          visit trainee_path(trainee.id)
          click_on "プロフィール変更"
          expect do
            fill_in "trainee_name", with: "updated_name"
            fill_in "trainee_age", with: 20
            select "male", from: "trainee_gender"
            fill_in "trainee_email", with: trainee.email
            fill_in "trainee_current_password", with: trainee.password
            check "trainee_dm_allowed"
            click_button "更新"

            aggregate_failures do
              expect(current_path).to eq trainee_path(trainee.id)
              expect(page).to have_content "アカウント情報を変更しました。"
            end
          end.to change { trainee.reload.name }.to("updated_name")
        end
      end

      context "入力値に問題がある場合" do
        scenario "更新しないこと" do
          login trainee
          visit trainee_path(trainee.id)
          click_on "プロフィール変更"
          expect do
            fill_in "trainee_name", with: "updated_name"
            fill_in "trainee_age", with: 20
            select "male", from: "trainee_gender"
            fill_in "trainee_email", with: trainee.email
            # current_passwordを一致させないことでエラー発生
            fill_in "trainee_current_password", with: "wrong_password"
            check "trainee_dm_allowed"
            click_button "更新"
          end.not_to change { trainee.reload.name }
        end
      end
    end
  end

  describe "Session" do
    let(:trainee) { create(:trainee) }

    context "入力値に問題がない場合" do
      scenario "ログインすること" do
        visit new_trainee_session_path
        fill_in "trainee_email", with: trainee.email
        fill_in "trainee_password", with: trainee.password
        click_button "ログイン"

        aggregate_failures do
          expect(current_path).to eq root_path
          expect(page).to have_content "ログインしました。"
        end
      end
    end

    context "入力値に問題がある場合" do
      scenario "ログインできないこと" do
        visit new_trainee_session_path
        # emailが一致しないため、エラー発生
        fill_in "trainee_email", with: "wrong_email@example.com"
        fill_in "trainee_password", with: trainee.password
        click_button "ログイン"

        aggregate_failures do
          expect(current_path).to eq new_trainee_session_path
          expect(page).to have_content "Eメールまたはパスワードが違います。"
        end
      end
    end

    scenario "ログイン中のトレーニーがログアウトすること" do
      login trainee
      click_on "ログアウト"
      aggregate_failures do
        expect(page).to have_content "ログアウトしました。"
        expect(current_path).to eq root_path
      end
    end
  end
end