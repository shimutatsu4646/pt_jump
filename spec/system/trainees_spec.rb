require 'rails_helper'

RSpec.describe "Trainees System", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "詳細ページ" do
    let(:trainee) { create(:trainee) }

    context "対象のトレーニーがログインユーザーの場合" do
      scenario "詳細ページにデータを更新するリンクが表示されていること" do
        login_as_trainee trainee
        visit trainee_path(trainee.id)
        expect(page).to have_content "プロフィールの変更"
        expect(page).to have_content "アカウント情報の変更"
      end
    end

    context "対象のトレーニーがログインユーザーではない場合" do
      let(:other_trainee) { create(:trainee, name: "other_trainee_name", email: "other_trainee@example.com") }

      scenario "詳細ページにデータを更新するリンクが表示されていないこと" do
        login_as_trainee other_trainee
        visit trainee_path(trainee.id)
        expect(page).not_to have_content "プロフィールの変更"
        expect(page).not_to have_content "アカウント情報の変更"
      end
    end

    describe "ActiveStorageのavatar" do
      scenario "アバター画像が表示されていること" do
        visit trainee_path(trainee.id)
        aggregate_failures do
          # src$=とすることでその後に続く文字列を含む画像ファイルを探している。
          expect(page).to have_selector "img[src$='default_trainee_avatar.png']"
        end
      end
    end
  end

  describe "トレーニーのプロフィールの変更" do
    let(:trainee) { create(:trainee) }

    context "入力値に問題がない場合" do
      scenario "更新すること" do
        login_as_trainee trainee
        visit trainee_path(trainee.id)
        click_on "プロフィールの変更"
        fill_in "trainee_name", with: "updated_name"
        fill_in "trainee_age", with: 30
        select "女性", from: "trainee_gender"
        check "trainee_dm_allowed"
        click_button "更新"

        aggregate_failures do
          expect(current_path).to eq trainee_path(trainee.id)
          expect(page).to have_content "プロフィール情報を変更しました。"
          expect(trainee.reload.name).to eq "updated_name"
          expect(trainee.reload.age).to eq 30
          expect(trainee.reload.gender).to eq "female"
          expect(trainee.reload.dm_allowed).to eq true
        end
      end
    end

    context "入力値に問題がある場合" do
      scenario "更新しないこと" do
        login_as_trainee trainee
        visit trainee_path(trainee.id)
        click_on "プロフィールの変更"
        expect do
          fill_in "trainee_name", with: nil
          fill_in "trainee_age", with: 30
          select "女性", from: "trainee_gender"
          check "trainee_dm_allowed"
          click_button "更新"
        end.not_to change { trainee.reload }
      end
    end

    describe "ActiveStorageのavatar" do
      scenario "画像ファイルがアップロードされて、アバターが変更されること" do
        login_as_trainee trainee
        visit trainee_path(trainee.id)
        expect(page).to have_selector "img[src$='default_trainee_avatar.png']"
        click_on "プロフィールの変更"
        attach_file "trainee[avatar]", "spec/fixtures/files/test_avatar_1.png"
        click_button "更新"

        expect(page).to have_selector "img[src$='test_avatar_1.png']"
        expect(trainee.reload.avatar.filename.to_s).to eq "test_avatar_1.png"
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
            select "男性", from: "trainee_gender"
            fill_in "trainee_email", with: "system_test1@example.com"
            fill_in "trainee_password", with: "test_password"
            fill_in "trainee_password_confirmation", with: "test_password"
            check "trainee_dm_allowed"
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
