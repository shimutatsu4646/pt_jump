require 'rails_helper'

RSpec.describe "TrainerRegistrations System", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "Registration" do
    describe "トレーナーの新規登録" do
      context "入力値に問題がない場合" do
        scenario "新規登録すること" do
          visit new_trainer_registration_path
          expect do
            fill_in "trainer_name", with: "test_trainer_name"
            fill_in "trainer_age", with: 20
            select "男性", from: "trainer_gender"
            fill_in "trainer_email", with: "system_test1@example.com"
            fill_in "trainer_password", with: "test_password"
            fill_in "trainer_password_confirmation", with: "test_password"
            click_button "登録"

            trainer = Trainer.find_by(name: "test_trainer_name")
            aggregate_failures do
              expect(current_path).to eq trainer_path(trainer.id)
              expect(page).to have_content "アカウント登録が完了しました。"
              expect(page).to have_selector "img[src$='default_trainer_avatar.png']"
            end
          end.to change { Trainer.count }.by(1)
        end
      end

      context "入力値に問題がある場合" do
        scenario "新規登録できないこと" do
          visit new_trainer_registration_path
          expect do
            # nameとageがnilのため、エラー発生
            fill_in "trainer_name", with: nil
            fill_in "trainer_age", with: nil
            select "男性", from: "trainer_gender"
            fill_in "trainer_email", with: "system_test2@example.com"
            fill_in "trainer_password", with: "test_password"
            fill_in "trainer_password_confirmation", with: "test_password"
            click_button "登録"

            aggregate_failures do
              expect(page).to have_content "名前を入力してください"
              expect(page).to have_content "年齢を入力してください"
            end
          end.to change { Trainer.count }.by(0)
        end
      end
    end

    describe "トレーナーのアカウント情報の更新" do
      let(:trainer) { create(:trainer) }

      context "入力値に問題がない場合" do
        scenario "更新すること" do
          login_as_trainer trainer
          visit trainer_path(trainer.id)
          click_on "アカウント情報の変更"
          expect do
            fill_in "trainer_email", with: "update_email@example.com"
            fill_in "trainer_current_password", with: trainer.password
            click_button "更新"

            aggregate_failures do
              expect(current_path).to eq trainer_path(trainer.id)
              expect(page).to have_content "アカウント情報を変更しました。"
            end
          end.to change { trainer.reload.email }.to("update_email@example.com")
        end
      end

      context "入力値に問題がある場合" do
        scenario "更新しないこと" do
          login_as_trainer trainer
          visit trainer_path(trainer.id)
          click_on "アカウント情報の変更"
          expect do
            fill_in "trainer_email", with: "update_email@example.com"
            # current_passwordをnilにすることでエラー発生
            fill_in "trainer_current_password", with: nil
            click_button "更新"
          end.not_to change { trainer.reload.email }
        end
      end
    end
  end

  describe "Session" do
    let(:trainer) { create(:trainer) }

    context "入力値に問題がない場合" do
      scenario "ログインすること" do
        visit new_trainer_session_path
        fill_in "trainer_email", with: trainer.email
        fill_in "trainer_password", with: trainer.password
        click_button "ログイン"

        aggregate_failures do
          expect(current_path).to eq root_path
          expect(page).to have_content "ログインしました。"
        end
      end
    end

    context "入力値に問題がある場合" do
      scenario "ログインできないこと" do
        visit new_trainer_session_path
        # emailが一致しないため、エラー発生
        fill_in "trainer_email", with: "wrong_email@example.com"
        fill_in "trainer_password", with: trainer.password
        click_button "ログイン"

        aggregate_failures do
          expect(current_path).to eq new_trainer_session_path
          expect(page).to have_content "Eメールまたはパスワードが違います。"
        end
      end
    end

    scenario "ログイン中のトレーナーがログアウトすること" do
      login_as_trainer trainer
      click_on "ログアウト"

      aggregate_failures do
        expect(page).to have_content "ログアウトしました。"
        expect(current_path).to eq root_path
      end
    end
  end
end
