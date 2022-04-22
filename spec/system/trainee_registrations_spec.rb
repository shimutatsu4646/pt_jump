require 'rails_helper'

RSpec.describe "TraineeRegistrations System", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "Registration" do
    describe "トレーニーの新規登録" do
      context "入力値に問題がない場合" do
        scenario "新規登録すること" do
          visit new_trainee_registration_path
          expect do
            fill_in "trainee_name", with: "test_trainee_name"
            fill_in "trainee_age", with: 20
            select "男性", from: "trainee_gender"
            fill_in "trainee_email", with: "system_test1@example.com"
            fill_in "trainee_password", with: "test_password"
            fill_in "trainee_password_confirmation", with: "test_password"
            check "trainee_chat_acceptance"
            click_button "登録"

            trainee = Trainee.find_by(name: "test_trainee_name")
            aggregate_failures do
              expect(current_path).to eq trainee_path(trainee.id)
              expect(page).to have_content "アカウント登録が完了しました。"
              expect(page).to have_selector "img[src$='default_trainee_avatar.png']"
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
            select "男性", from: "trainee_gender"
            fill_in "trainee_email", with: "system_test2@example.com"
            fill_in "trainee_password", with: "test_password"
            fill_in "trainee_password_confirmation", with: "test_password"
            check "trainee_chat_acceptance"
            click_button "登録"

            aggregate_failures do
              expect(page).to have_content "名前を入力してください"
              expect(page).to have_content "年齢を入力してください"
            end
          end.to change { Trainee.count }.by(0)
        end
      end
    end

    describe "トレーニーのアカウント情報の更新" do
      let(:trainee) { create(:trainee) }

      context "入力値に問題がない場合" do
        scenario "更新すること" do
          login_as_trainee trainee
          visit trainee_path(trainee.id)
          click_on "アカウント情報の変更"
          expect do
            fill_in "trainee_email", with: "update_email@example.com"
            fill_in "trainee_current_password", with: trainee.password
            click_button "更新"

            aggregate_failures do
              expect(current_path).to eq trainee_path(trainee.id)
              expect(page).to have_content "アカウント情報を変更しました。"
            end
          end.to change { trainee.reload.email }.to("update_email@example.com")
        end
      end

      context "入力値に問題がある場合" do
        scenario "更新しないこと" do
          login_as_trainee trainee
          visit trainee_path(trainee.id)
          click_on "アカウント情報の変更"
          expect do
            fill_in "trainee_email", with: "update_email@example.com"
            # current_passwordをnilにすることでエラー発生
            fill_in "trainee_current_password", with: nil
            click_button "更新"
          end.not_to change { trainee.reload.email }
        end
      end
    end

    describe "トレーニーの退会" do
      describe "DELETE /trainees" do
        let(:trainee) { create(:trainee) }
        let(:trainer) { create(:trainer) }

        let!(:candidate) do
          create(:candidate, trainee_id: trainee.id, trainer_id: trainer.id)
        end

        let!(:chat) do
          create(:chat,
            trainee_id: trainee.id, trainer_id: trainer.id,
            content: "hello.", from_trainee: true)
        end

        let!(:contract) do
          create(:contract, trainee_id: trainee.id, trainer_id: trainer.id, final_decision: false)
        end

        before do
          login_as_trainee trainee
        end

        scenario "「退会する」ボタンをクリックすると、トレーニーデータと、そのトレーニーに関連付いているデータが削除される" do
          aggregate_failures do
            expect(trainee.candidates.empty?).to eq false
            expect(trainee.chats.empty?).to eq false
            expect(trainee.contracts.empty?).to eq false
          end

          visit edit_trainee_registration_path
          expect do
            click_on "退会する"
          end.to change { Trainee.count }.by(-1)
          aggregate_failures do
            expect(trainee.candidates.empty?).to eq true
            expect(trainee.chats.empty?).to eq true
            expect(trainee.contracts.empty?).to eq true
            expect(current_path).to eq root_path
          end
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
      login_as_trainee trainee
      click_on "ログアウト"

      aggregate_failures do
        expect(page).to have_content "ログアウトしました。"
        expect(current_path).to eq root_path
      end
    end
  end
end
