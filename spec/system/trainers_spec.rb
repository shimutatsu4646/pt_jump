require 'rails_helper'

RSpec.describe "Trainers System", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "詳細ページ" do
    let(:trainer) { create(:trainer) }

    context "対象のトレーナーがログインユーザー自身の場合" do
      before do
        login_as_trainer trainer
      end

      scenario "「プロフィールの変更」リンクが表示されていること" do
        visit trainer_path(trainer.id)
        expect(page).to have_link "プロフィールの変更"
      end

      scenario "「アカウント情報の変更」リンクが表示されていること" do
        visit trainer_path(trainer.id)
        expect(page).to have_link "アカウント情報の変更"
      end

      scenario "「〜さんとのチャットページ」リンクが表示されていないこと" do
        visit trainer_path(trainer.id)
        expect(page).not_to have_link "#{trainer.name}さんとのチャットページ"
      end

      describe "ActiveStorageのavatar" do
        scenario "アバター画像が表示されていること" do
          visit trainer_path(trainer.id)
          expect(page).to have_selector "img[src$='default_trainer_avatar.png']"
        end
      end
    end

    context "トレー二ーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }

      before do
        login_as_trainee trainee
      end

      scenario "「プロフィールの変更」リンクが表示されていないこと" do
        visit trainer_path(trainer.id)
        expect(page).not_to have_link "プロフィールの変更"
      end

      scenario "「アカウント情報の変更」リンクが表示されていないこと" do
        visit trainer_path(trainer.id)
        expect(page).not_to have_link "アカウント情報の変更"
      end

      scenario "「〜さんとのチャットページ」リンクが表示されること" do
        visit trainer_path(trainer.id)
        expect(page).to have_link "#{trainer.name}さんとのチャットページ"
      end

      describe "ActiveStorageのavatar" do
        scenario "アバター画像が表示されていること" do
          visit trainer_path(trainer.id)
          expect(page).to have_selector "img[src$='default_trainer_avatar.png']"
        end
      end

      describe "トレーナーとの契約" do
        context "このトレーナーに契約リクエストをしていない場合" do
          scenario "「このトレーナーにリクエストした契約はありません」と表示されること" do
            visit trainer_path(trainer.id)
            expect(page).to have_content "このトレーニーにリクエストした契約はありません"
          end
        end

        context "このトレーナーと成立した契約がない場合" do
          scenario "「このトレーナーと成立した契約はありません」と表示されること" do
            visit trainer_path(trainer.id)
            expect(page).to have_content "このトレーナーと成立した契約はありません"
          end
        end

        context "このトレーナーに契約リクエストをした場合" do
          let!(:contract) { create(:contract, trainee_id: trainee.id, trainer_id: trainer.id, final_decision: false) }

          scenario "「このトレーナーにリクエストした契約」と表示されること" do
            visit trainer_path(trainer.id)
            expect(page).to have_content "このトレー二ーにリクエストした契約"
          end

          scenario "「この契約リクエストの詳細を見る」をクリックすると、契約詳細ページにリダイレクトすること" do
            visit trainer_path(trainer.id)
            click_on "この契約リクエストの詳細を見る"
            expect(current_path).to eq contract_path(contract.id)
          end
        end

        context "このトレーニーと成立した契約がある場合" do
          let!(:contract) { create(:contract, trainee_id: trainee.id, trainer_id: trainer.id, final_decision: true) }

          scenario "「このトレーニーと成立した契約」と表示されること" do
            visit trainer_path(trainer.id)
            expect(page).to have_content "このトレー二ーと成立した契約"
          end

          scenario "「この契約の詳細を見る」をクリックすると、契約詳細ページにリダイレクトすること" do
            visit trainer_path(trainer.id)
            click_on "この契約の詳細を見る"
            expect(current_path).to eq contract_path(contract.id)
          end
        end
      end

      describe "トレーナー候補" do
        context "トレーナー候補に加えていない場合" do
          scenario "「トレーナー候補に加える」ボタンを押すと、トレーナー候補に追加されること" do
            visit trainer_path(trainer.id)
            expect do
              click_on "トレーナー候補に加える"
            end.to change { Candidate.count }.by(1)
          end
        end

        context "トレーナー候補に加えている場合" do
          let!(:candidate) do
            create(:candidate,
            trainee_id: trainee.id,
            trainer_id: trainer.id)
          end

          scenario "「トレーナー候補から取り消す」ボタンを押すと、トレーナー候補データが削除されること" do
            visit trainer_path(trainer.id)
            expect do
              click_on "トレーナー候補から取り消す"
            end.to change { Candidate.count }.by(-1)
          end
        end
      end
    end
  end

  describe "トレーナーのプロフィールの更新" do
    let(:trainer) { create(:trainer) }

    context "入力値に問題がない場合" do
      scenario "更新すること" do
        login_as_trainer trainer
        visit trainer_path(trainer.id)
        click_on "プロフィールの変更"

        fill_in "trainer_name", with: "updated_name"
        fill_in "trainer_introduction", with: "Added introduction."
        select "筋肉づくり", from: "trainer_category"
        select "オフラインで指導", from: "trainer_instruction_method"
        fill_in "trainer_min_fee", with: 1000
        select "一ヶ月未満", from: "trainer_instruction_period"
        check "trainer_city_ids_1093"
        check "trainer_city_ids_1119"
        check "trainer_city_ids_1120"
        check "trainer_day_of_week_ids_6"
        check "trainer_day_of_week_ids_7"
        click_button "更新"

        aggregate_failures do
          expect(current_path).to eq trainer_path(trainer.id)
          expect(page).to have_content "プロフィール情報を変更しました。"
          expect(trainer.reload.name).to eq "updated_name"
          expect(trainer.reload.introduction).to eq "Added introduction."
          expect(trainer.reload.category).to eq "building_muscle"
          expect(trainer.reload.instruction_method).to eq "offline"
          expect(trainer.reload.min_fee).to eq 1000
          expect(trainer.reload.instruction_period).to eq "below_one_month"
          expect(trainer.cities.first.name).to eq "京都市"
          expect(trainer.cities.second.name).to eq "大阪市"
          expect(trainer.cities.third.name).to eq "堺市"
          expect(trainer.day_of_weeks.first.name).to eq "土曜日"
          expect(trainer.day_of_weeks.second.name).to eq "日曜日"
          expect(page).to have_content "updated_name"
          expect(page).to have_content "Added introduction."
          expect(page).to have_content "筋肉づくり"
          expect(page).to have_content "オフラインで指導"
          expect(page).to have_content "1000円"
          expect(page).to have_content "一ヶ月未満"
          expect(page).to have_content "京都府"
          expect(page).to have_content "京都市"
          expect(page).to have_content "大阪府"
          expect(page).to have_content "大阪市"
          expect(page).to have_content "堺市"
          expect(page).to have_content "土曜日"
          expect(page).to have_content "日曜日"
        end
      end
    end

    context "入力値に問題がある場合" do
      scenario "nameの入力がない時、更新しないこと" do
        login_as_trainer trainer
        visit trainer_path(trainer.id)
        click_on "プロフィールの変更"
        expect do
          fill_in "trainer_name", with: nil
          fill_in "trainer_introduction", with: "Added introduction."
          select "筋肉づくり", from: "trainer_category"
          select "オンラインで指導", from: "trainer_instruction_method"
          fill_in "trainer_min_fee", with: 1000
          select "一ヶ月未満", from: "trainer_instruction_period"
          click_button "更新"
        end.not_to change { trainer.reload }
      end
    end

    describe "ActiveStorageのavatar" do
      scenario "画像ファイルがアップロードされて、アバターが変更されること" do
        login_as_trainer trainer
        visit trainer_path(trainer.id)
        expect(page).to have_selector "img[src$='default_trainer_avatar.png']"
        click_on "プロフィールの変更"
        attach_file "trainer[avatar]", "spec/fixtures/files/test_avatar_1.png"
        click_button "更新"

        expect(page).to have_selector "img[src$='test_avatar_1.png']"
        expect(trainer.reload.avatar.filename.to_s).to eq "test_avatar_1.png"
      end
    end
  end

  describe "トレーナー検索" do
    let!(:trainer1) do
      create(:trainer,
      name: "trainer1", age: 21,
      gender: "male", category: "losing_weight",
      min_fee: 1000, instruction_method: "online",
      instruction_period: "below_one_month")
    end

    let!(:trainer2) do
      create(:trainer,
      name: "trainer2", age: 22,
      gender: "female", category: "building_muscle",
      min_fee: 2000, instruction_method: "offline",
      instruction_period: "below_one_month")
    end

    let!(:trainer3) do
      create(:trainer,
      name: "trainer3", age: 23,
      gender: "male", category: "physical_function",
      min_fee: 3000, instruction_method: "online",
      instruction_period: "above_one_month")
    end

    let!(:trainer4) do
      create(:trainer,
      name: "trainer4", age: 24,
      gender: "female", category: "physical_therapy",
      min_fee: 4000, instruction_method: "offline",
      instruction_period: "above_one_month")
    end

    let(:trainee) { create(:trainee) }

    before do
      login_as_trainee trainee
    end

    scenario "トレーナー検索ページに訪れると、検索フォームがあり、トレーナーは１件も表示されていないこと" do
      visit root_path

      click_on "トレーナー検索"
      aggregate_failures do
        expect(current_path).to eq search_for_trainer_path
        expect(page).to have_selector "#collapseSearch"
        expect(page).not_to have_selector "ul.search-result"
        expect(page).not_to have_content(trainer1.name)
      end
    end

    context "検索条件を入力しない場合" do
      scenario "フォームに入力せず「この条件で検索する」ボタンをクリックすると、トレーナーを全件取得すること" do
        visit search_for_trainer_path
        click_button "この条件で検索する"
        aggregate_failures do
          expect(current_path).to eq search_for_trainer_path
          expect(page).to have_selector "#collapseSearch"
          expect(page).to have_selector "ul.search-result", count: 4
          expect(page).to have_content(trainer1.name)
          expect(page).to have_content(trainer2.name)
          expect(page).to have_content(trainer3.name)
          expect(page).to have_content(trainer4.name)
        end
      end

      scenario "「検索条件・検索結果をリセットする」ボタンをクリックすると、同じページにリダイレクトすること" do
        visit search_for_trainer_path
        click_button "検索条件・検索結果をリセットする"
        aggregate_failures do
          expect(current_path).to eq search_for_trainer_path
          expect(page).to have_selector "#collapseSearch"
          expect(page).not_to have_selector "ul.search-result"
          expect(page).not_to have_content(trainer1.name)
          expect(page).not_to have_content(trainer2.name)
          expect(page).not_to have_content(trainer3.name)
          expect(page).not_to have_content(trainer4.name)
        end
      end
    end

    context "検索条件を入力する場合" do
      scenario "年齢の範囲を条件にして検索できること" do
        visit search_for_trainer_path
        fill_in "search_trainer_age_from", with: 22
        fill_in "search_trainer_age_to", with: 23
        click_button "この条件で検索する"
        aggregate_failures do
          expect(page).not_to have_content(trainer1.name)
          expect(page).to have_content(trainer2.name)
          expect(page).to have_content(trainer3.name)
          expect(page).not_to have_content(trainer4.name)
        end
      end

      scenario "最低料金の範囲を条件にして検索できること" do
        visit search_for_trainer_path
        fill_in "search_trainer_min_fee_from", with: 1000
        fill_in "search_trainer_min_fee_to", with: 3000
        click_button "この条件で検索する"
        aggregate_failures do
          expect(page).to have_content(trainer1.name)
          expect(page).to have_content(trainer2.name)
          expect(page).to have_content(trainer3.name)
          expect(page).not_to have_content(trainer4.name)
        end
      end

      scenario "性別を条件にして検索できること" do
        visit search_for_trainer_path
        select "男性", from: "search_trainer_gender"
        click_button "この条件で検索する"
        aggregate_failures do
          expect(page).to have_content(trainer1.name)
          expect(page).not_to have_content(trainer2.name)
          expect(page).to have_content(trainer3.name)
          expect(page).not_to have_content(trainer4.name)
        end
      end

      scenario "カテゴリーを条件にして検索できること" do
        visit search_for_trainer_path
        select "筋肉づくり", from: "search_trainer_category"
        click_button "この条件で検索する"
        aggregate_failures do
          expect(page).not_to have_content(trainer1.name)
          expect(page).to have_content(trainer2.name)
          expect(page).not_to have_content(trainer3.name)
          expect(page).not_to have_content(trainer4.name)
        end
      end

      scenario "指導方法を条件にして検索できること" do
        visit search_for_trainer_path
        select "オンラインで指導", from: "search_trainer_instruction_method"
        click_button "この条件で検索する"
        aggregate_failures do
          expect(page).to have_content(trainer1.name)
          expect(page).not_to have_content(trainer2.name)
          expect(page).to have_content(trainer3.name)
          expect(page).not_to have_content(trainer4.name)
        end
      end

      scenario "指導期間を条件にして検索できること" do
        visit search_for_trainer_path
        select "一ヶ月未満", from: "search_trainer_instruction_period"
        click_button "この条件で検索する"
        aggregate_failures do
          expect(page).to have_content(trainer1.name)
          expect(page).to have_content(trainer2.name)
          expect(page).not_to have_content(trainer3.name)
          expect(page).not_to have_content(trainer4.name)
        end
      end

      describe "活動地域を条件に含む検索操作" do
        before do
          trainer1.cities << City.where(id: 1) # 札幌市
          trainer2.cities << City.where(id: [1, 2]) # 札幌市＆函館市
          trainer3.cities << City.where(id: [1, 2, 3]) # 札幌市＆函館市＆小樽市
          trainer4.cities << City.where(id: [636, 696]) # 東京都：港区、神奈川県：横浜市
        end

        scenario "活動地域を条件にして検索できること" do
          visit search_for_trainer_path
          check "search_trainer_city_ids_1"
          check "search_trainer_city_ids_2"
          click_button "この条件で検索する"
          aggregate_failures do
            expect(page).to have_content(trainer1.name)
            expect(page).to have_content(trainer2.name)
            expect(page).to have_content(trainer3.name)
            expect(page).not_to have_content(trainer4.name)
          end
        end

        scenario "複数の都道府県を含む市区町村を条件にして検索できること" do
          visit search_for_trainer_path
          check "search_trainer_city_ids_636"
          check "search_trainer_city_ids_696"
          click_button "この条件で検索する"
          aggregate_failures do
            expect(page).not_to have_content(trainer1.name)
            expect(page).not_to have_content(trainer2.name)
            expect(page).not_to have_content(trainer3.name)
            expect(page).to have_content(trainer4.name)
          end
        end
      end

      describe "活動できる曜日を条件に含む検索操作" do
        before do
          trainer1.day_of_weeks << DayOfWeek.where(id: 1)
          trainer2.day_of_weeks << DayOfWeek.where(id: [1, 2])
          trainer3.day_of_weeks << DayOfWeek.where(id: [1, 2, 3, 4, 5])
          trainer4.day_of_weeks << DayOfWeek.where(id: [6, 7])
        end

        scenario "活動できる曜日を条件にして検索できること" do
          visit search_for_trainer_path
          check "search_trainer_day_of_week_ids_1"
          check "search_trainer_day_of_week_ids_3"
          click_button "この条件で検索する"
          aggregate_failures do
            expect(page).to have_content(trainer1.name)
            expect(page).to have_content(trainer2.name)
            expect(page).to have_content(trainer3.name)
            expect(page).not_to have_content(trainer4.name)
          end
        end
      end

      describe "複数の条件を含む検索操作" do
        before do
          trainer1.cities << City.where(id: 1) # 札幌市
          trainer2.cities << City.where(id: [1, 2]) # 札幌市＆函館市
          trainer3.cities << City.where(id: [1, 2, 3]) # 札幌市＆函館市＆小樽市
          trainer4.cities << City.where(id: [636, 696]) # 東京都：港区、神奈川県：横浜市
          trainer1.day_of_weeks << DayOfWeek.where(id: 1)
          trainer2.day_of_weeks << DayOfWeek.where(id: [1, 2])
          trainer3.day_of_weeks << DayOfWeek.where(id: [1, 2, 3, 4, 5])
          trainer4.day_of_weeks << DayOfWeek.where(id: [6, 7])
        end

        scenario "複数の条件を組み合わせて検索できること" do
          visit search_for_trainer_path
          fill_in "search_trainer_age_from", with: 20
          fill_in "search_trainer_age_to", with: 25
          fill_in "search_trainer_min_fee_from", with: 1000
          fill_in "search_trainer_min_fee_to", with: 3000
          select "男性", from: "search_trainer_gender"
          select "ダイエット", from: "search_trainer_category"
          select "オンラインで指導", from: "search_trainer_instruction_method"
          select "一ヶ月未満", from: "search_trainer_instruction_period"
          check "search_trainer_city_ids_1"
          check "search_trainer_city_ids_2"
          check "search_trainer_day_of_week_ids_1"
          check "search_trainer_day_of_week_ids_3"
          click_button "この条件で検索する"
          aggregate_failures do
            expect(page).to have_content(trainer1.name)
            expect(page).not_to have_content(trainer2.name)
            expect(page).not_to have_content(trainer3.name)
            expect(page).not_to have_content(trainer4.name)
          end
        end
      end
    end

    describe "トレーナー候補" do
      context "トレーナー候補に加えていない場合" do
        scenario "「トレーナー候補に加える」ボタンを押すと、トレーナー候補に追加されること" do
          visit search_for_trainer_path
          click_on "この条件で検索する"
          expect do
            within(:css, "#candidate_#{trainer1.id}") do
              click_on "トレーナー候補に加える"
            end
          end.to change { Candidate.count }.by(1)
        end
      end

      context "トレーナー候補に加えている場合" do
        # trainer1のみ候補に加わっているものとする
        let!(:candidate1) do
          create(:candidate,
          trainee_id: trainee.id,
          trainer_id: trainer1.id)
        end

        scenario "「トレーナー候補から取り消す」ボタンを押すと、トレーナー候補データが削除されること" do
          visit search_for_trainer_path
          click_on "この条件で検索する"
          expect do
            within(:css, "#candidate_#{trainer1.id}") do
              click_on "トレーナー候補から取り消す"
            end
          end.to change { Candidate.count }.by(-1)
        end
      end
    end
  end

  # DEVISE MODULE--------------------------------------------------------

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
