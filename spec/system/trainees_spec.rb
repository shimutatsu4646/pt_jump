require 'rails_helper'

RSpec.describe "Trainees System", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "詳細ページ" do
    let(:trainee) { create(:trainee) }

    context "対象のトレーニーがログインユーザー自身の場合" do
      scenario "詳細ページにデータを更新するリンクが表示されていること" do
        login_as_trainee trainee
        visit trainee_path(trainee.id)
        expect(page).to have_content "プロフィールの変更"
        expect(page).to have_content "アカウント情報の変更"
      end
    end

    context "対象のトレーニーがログインユーザー自身ではない場合" do
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

  describe "トレーニーのプロフィールの更新" do
    let(:trainee) { create(:trainee) }

    context "入力値に問題がない場合" do
      scenario "更新すること" do
        login_as_trainee trainee
        visit trainee_path(trainee.id)
        click_on "プロフィールの変更"

        fill_in "trainee_name", with: "updated_name"
        fill_in "trainee_introduction", with: "Added introduction."
        select "筋肉づくり", from: "trainee_category"
        select "オンラインで指導", from: "trainee_instruction_method"
        check "trainee_chat_acceptance"
        check "trainee_city_ids_634"
        check "trainee_city_ids_635"
        check "trainee_city_ids_636"
        check "trainee_day_of_week_ids_1"
        check "trainee_day_of_week_ids_2"
        click_button "更新"

        aggregate_failures do
          expect(current_path).to eq trainee_path(trainee.id)
          expect(page).to have_content "プロフィール情報を変更しました。"
          expect(trainee.reload.name).to eq "updated_name"
          expect(trainee.reload.introduction).to eq "Added introduction."
          expect(trainee.reload.category).to eq "building_muscle"
          expect(trainee.reload.instruction_method).to eq "online"
          expect(trainee.reload.chat_acceptance).to eq true
          expect(trainee.cities.first.name).to eq "千代田区"
          expect(trainee.cities.second.name).to eq "中央区"
          expect(trainee.cities.third.name).to eq "港区"
          expect(trainee.day_of_weeks.first.name).to eq "月曜日"
          expect(trainee.day_of_weeks.second.name).to eq "火曜日"
          expect(page).to have_content "updated_name"
          expect(page).to have_content "Added introduction."
          expect(page).to have_content "筋肉づくり"
          expect(page).to have_content "オンラインで指導"
          expect(page).to have_content "許可する"
          expect(page).to have_content "東京都"
          expect(page).to have_content "千代田区"
          expect(page).to have_content "中央区"
          expect(page).to have_content "港区"
          expect(page).to have_content "月曜日"
          expect(page).to have_content "火曜日"
        end
      end
    end

    context "入力値に問題がある場合" do
      scenario "nameの入力がない時、更新しないこと" do
        login_as_trainee trainee
        visit trainee_path(trainee.id)
        click_on "プロフィールの変更"
        expect do
          fill_in "trainee_name", with: nil
          fill_in "trainee_introduction", with: "Added introduction."
          select "筋肉づくり", from: "trainee_category"
          select "オンラインで指導", from: "trainee_instruction_method"
          check "trainee_chat_acceptance"
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

  describe "トレーニー検索" do
    let!(:trainee1) do
      create(:trainee,
      name: "trainee1", age: 21,
      gender: "male", category: "losing_weight",
      instruction_method: "online", chat_acceptance: true)
    end

    let!(:trainee2) do
      create(:trainee,
      name: "trainee2", age: 22,
      gender: "female", category: "building_muscle",
      instruction_method: "offline", chat_acceptance: true)
    end

    let!(:trainee3) do
      create(:trainee,
      name: "trainee3", age: 23,
      gender: "male", category: "physical_function",
      instruction_method: "online", chat_acceptance: true)
    end

    let!(:trainee4) do
      create(:trainee,
      name: "trainee4", age: 24,
      gender: "female", category: "physical_therapy",
      instruction_method: "offline", chat_acceptance: false)
    end

    let(:trainer) { create(:trainer) }

    scenario "トレーニー検索ページに訪れると、検索フォームがあり、トレーニーは１件も表示されていないこと" do
      login_as_trainer trainer
      visit root_path

      click_on "トレーニー検索"
      aggregate_failures do
        expect(current_path).to eq search_for_trainee_path
        expect(page).to have_selector "#collapseSearch"
        expect(page).not_to have_selector "ul.search-result"
        expect(page).not_to have_content(trainee1.name)
      end
    end

    context "検索条件を入力しない場合" do
      scenario "フォームに入力せず「この条件で検索する」ボタンをクリックすると、トレー二ーを全件取得すること" do
        login_as_trainer trainer
        visit search_for_trainee_path

        click_button "この条件で検索する"
        aggregate_failures do
          expect(current_path).to eq search_for_trainee_path
          expect(page).to have_selector "#collapseSearch"
          expect(page).to have_selector "ul.search-result", count: 4
          expect(page).to have_content(trainee1.name)
          expect(page).to have_content(trainee2.name)
          expect(page).to have_content(trainee3.name)
          expect(page).to have_content(trainee4.name)
        end
      end

      scenario "「検索条件・検索結果をリセットする」ボタンをクリックすると、同じページにリダイレクトすること" do
        login_as_trainer trainer
        visit search_for_trainee_path

        click_button "検索条件・検索結果をリセットする"
        aggregate_failures do
          expect(current_path).to eq search_for_trainee_path
          expect(page).to have_selector "#collapseSearch"
          expect(page).not_to have_selector "ul.search-result"
          expect(page).not_to have_content(trainee1.name)
          expect(page).not_to have_content(trainee2.name)
          expect(page).not_to have_content(trainee3.name)
          expect(page).not_to have_content(trainee4.name)
        end
      end
    end

    context "検索条件を入力する場合" do
      scenario "年齢の範囲を条件にして検索できること" do
        login_as_trainer trainer
        visit search_for_trainee_path

        fill_in "search_trainee_age_from", with: 22
        fill_in "search_trainee_age_to", with: 23
        click_button "この条件で検索する"
        aggregate_failures do
          expect(page).not_to have_content(trainee1.name)
          expect(page).to have_content(trainee2.name)
          expect(page).to have_content(trainee3.name)
          expect(page).not_to have_content(trainee4.name)
        end
      end

      scenario "性別を条件にして検索できること" do
        login_as_trainer trainer
        visit search_for_trainee_path

        select "男性", from: "search_trainee_gender"
        click_button "この条件で検索する"
        aggregate_failures do
          expect(page).to have_content(trainee1.name)
          expect(page).not_to have_content(trainee2.name)
          expect(page).to have_content(trainee3.name)
          expect(page).not_to have_content(trainee4.name)
        end
      end

      scenario "カテゴリーを条件にして検索できること" do
        login_as_trainer trainer
        visit search_for_trainee_path

        select "筋肉づくり", from: "search_trainee_category"
        click_button "この条件で検索する"
        aggregate_failures do
          expect(page).not_to have_content(trainee1.name)
          expect(page).to have_content(trainee2.name)
          expect(page).not_to have_content(trainee3.name)
          expect(page).not_to have_content(trainee4.name)
        end
      end

      scenario "指導方法を条件にして検索できること" do
        login_as_trainer trainer
        visit search_for_trainee_path

        select "オンラインで指導", from: "search_trainee_instruction_method"
        click_button "この条件で検索する"
        aggregate_failures do
          expect(page).to have_content(trainee1.name)
          expect(page).not_to have_content(trainee2.name)
          expect(page).to have_content(trainee3.name)
          expect(page).not_to have_content(trainee4.name)
        end
      end

      scenario "チャットの受け入れ可否を条件にして検索できること" do
        login_as_trainer trainer
        visit search_for_trainee_path

        check "search_trainee_chat_acceptance"
        click_button "この条件で検索する"
        aggregate_failures do
          expect(page).to have_content(trainee1.name)
          expect(page).to have_content(trainee2.name)
          expect(page).to have_content(trainee3.name)
          expect(page).not_to have_content(trainee4.name)
        end
      end

      describe "活動地域を条件に含む検索操作" do
        before do
          trainee1.cities << City.where(id: 1) # 札幌市
          trainee2.cities << City.where(id: [1, 2]) # 札幌市＆函館市
          trainee3.cities << City.where(id: [1, 2, 3]) # 札幌市＆函館市＆小樽市
          trainee4.cities << City.where(id: [636, 696]) # 東京都：港区、神奈川県：横浜市
        end

        scenario "活動地域を条件にして検索できること" do
          login_as_trainer trainer
          visit search_for_trainee_path

          check "search_trainee_city_ids_1"
          check "search_trainee_city_ids_2"
          click_button "この条件で検索する"
          aggregate_failures do
            expect(page).to have_content(trainee1.name)
            expect(page).to have_content(trainee2.name)
            expect(page).to have_content(trainee3.name)
            expect(page).not_to have_content(trainee4.name)
          end
        end

        scenario "複数の都道府県を含む市区町村を条件にして検索できること" do
          login_as_trainer trainer
          visit search_for_trainee_path

          check "search_trainee_city_ids_636"
          check "search_trainee_city_ids_696"
          click_button "この条件で検索する"
          aggregate_failures do
            expect(page).not_to have_content(trainee1.name)
            expect(page).not_to have_content(trainee2.name)
            expect(page).not_to have_content(trainee3.name)
            expect(page).to have_content(trainee4.name)
          end
        end
      end

      describe "活動できる曜日を条件に含む検索操作" do
        before do
          trainee1.day_of_weeks << DayOfWeek.where(id: 1)
          trainee2.day_of_weeks << DayOfWeek.where(id: [1, 2])
          trainee3.day_of_weeks << DayOfWeek.where(id: [1, 2, 3, 4, 5])
          trainee4.day_of_weeks << DayOfWeek.where(id: [6, 7])
        end

        scenario "活動できる曜日を条件にして検索できること" do
          login_as_trainer trainer
          visit search_for_trainee_path

          check "search_trainee_day_of_week_ids_1"
          check "search_trainee_day_of_week_ids_3"
          click_button "この条件で検索する"
          aggregate_failures do
            expect(page).to have_content(trainee1.name)
            expect(page).to have_content(trainee2.name)
            expect(page).to have_content(trainee3.name)
            expect(page).not_to have_content(trainee4.name)
          end
        end
      end

      describe "複数の条件を含む検索操作" do
        before do
          trainee1.cities << City.where(id: 1) # 札幌市
          trainee2.cities << City.where(id: [1, 2]) # 札幌市＆函館市
          trainee3.cities << City.where(id: [1, 2, 3]) # 札幌市＆函館市＆小樽市
          trainee4.cities << City.where(id: [636, 696]) # 東京都：港区、神奈川県：横浜市
          trainee1.day_of_weeks << DayOfWeek.where(id: 1)
          trainee2.day_of_weeks << DayOfWeek.where(id: [1, 2])
          trainee3.day_of_weeks << DayOfWeek.where(id: [1, 2, 3, 4, 5])
          trainee4.day_of_weeks << DayOfWeek.where(id: [6, 7])
        end

        scenario "複数の条件を組み合わせて検索できること" do
          login_as_trainer trainer
          visit search_for_trainee_path

          fill_in "search_trainee_age_from", with: 20
          fill_in "search_trainee_age_to", with: 25
          select "男性", from: "search_trainee_gender"
          select "ダイエット", from: "search_trainee_category"
          select "オンラインで指導", from: "search_trainee_instruction_method"
          check "search_trainee_chat_acceptance"
          check "search_trainee_city_ids_1"
          check "search_trainee_city_ids_2"
          check "search_trainee_day_of_week_ids_1"
          check "search_trainee_day_of_week_ids_3"
          click_button "この条件で検索する"
          aggregate_failures do
            expect(page).to have_content(trainee1.name)
            expect(page).not_to have_content(trainee2.name)
            expect(page).not_to have_content(trainee3.name)
            expect(page).not_to have_content(trainee4.name)
          end
        end
      end
    end
  end

  # DEVISE MODULE--------------------------------------------------------

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
