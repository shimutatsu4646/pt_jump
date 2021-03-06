require 'rails_helper'

RSpec.describe "Trainees System", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "詳細ページ" do
    let(:trainee) { create(:trainee, name: "show_trainee") }

    context "対象のトレーニーがログインユーザー自身の場合" do
      before do
        login_as_trainee trainee
      end

      scenario "「プロフィールの変更」リンクが表示されていること" do
        visit trainee_path(trainee.id)
        expect(page).to have_link "プロフィールの変更"
      end

      scenario "「アカウント情報の変更」リンクが表示されていること" do
        visit trainee_path(trainee.id)
        expect(page).to have_link "アカウント情報の変更"
      end

      scenario "「〜さんとのチャットページ」リンクが表示されていないこと" do
        visit trainee_path(trainee.id)
        expect(page).not_to have_link "#{trainee.name}さんとのチャットページ"
      end

      describe "ActiveStorageのavatar" do
        scenario "アバター画像が表示されていること" do
          visit trainee_path(trainee.id)
          expect(page).to have_selector "img[src$='default_trainee_avatar.png']"
        end
      end
    end

    context "トレーナーとしてログインしている場合" do
      let(:trainer) { create(:trainer) }

      before do
        login_as_trainer trainer
      end

      scenario "「プロフィールの変更」リンクが表示されていないこと" do
        visit trainee_path(trainee.id)
        expect(page).not_to have_link "プロフィールの変更"
      end

      scenario "「アカウント情報の変更」リンクが表示されていないこと" do
        visit trainee_path(trainee.id)
        expect(page).not_to have_link "アカウント情報の変更"
      end

      describe "チャットページヘのリンクの有無" do
        context "traineeのchat_acceptanceがtrueの場合" do
          let(:accepting_trainee) { create(:trainee, chat_acceptance: true) }

          scenario "「〜さんとのチャットページ」リンクが表示されること" do
            visit trainee_path(accepting_trainee.id)
            expect(page).to have_link "#{accepting_trainee.name}さんとのチャットページ"
          end
        end

        context "traineeのchat_acceptanceがfalseの場合" do
          let(:rejecting_trainee) { create(:trainee, chat_acceptance: false) }

          context "このトレーニーとのチャット履歴・契約履歴がない場合" do
            scenario "「〜さんとのチャットページ」リンクが表示されていないこと" do
              visit trainee_path(rejecting_trainee.id)
              expect(page).not_to have_link "#{rejecting_trainee.name}さんとのチャットページ"
            end
          end

          context "このトレーニーとのチャット履歴がある場合" do
            let!(:chat) do
              create(:chat,
                trainee_id: rejecting_trainee.id, trainer_id: trainer.id,
                content: "hello.", from_trainee: true)
            end

            scenario "「〜さんとのチャットページ」リンクが表示されること" do
              visit trainee_path(rejecting_trainee.id)
              expect(page).to have_link "#{rejecting_trainee.name}さんとのチャットページ"
            end
          end

          context "このトレーニーとの契約履歴がある場合" do
            let!(:contract) do
              create(:contract,
                trainee_id: rejecting_trainee.id, trainer_id: trainer.id,
                final_decision: false)
            end

            scenario "「〜さんとのチャットページ」リンクが表示されないこと" do
              # 契約詳細ページからチャットページリンクに触れるため。
              visit trainee_path(rejecting_trainee.id)
              expect(page).not_to have_link "#{rejecting_trainee.name}さんとのチャットページ"
            end
          end
        end
      end

      describe "ActiveStorageのavatar" do
        scenario "アバター画像が表示されていること" do
          visit trainee_path(trainee.id)
          expect(page).to have_selector "img[src$='default_trainee_avatar.png']"
        end
      end

      describe "トレーニーとの契約" do
        context "このトレーニーからの契約リクエストがない場合" do
          scenario "「このトレーニーからリクエストされた契約はありません」と表示されること" do
            visit trainee_path(trainee.id)
            expect(page).to have_content "このトレーニーからリクエストされた契約はありません"
          end
        end

        context "このトレーニーと成立した契約がない場合" do
          scenario "「このトレーニーと成立した契約はありません」と表示されること" do
            visit trainee_path(trainee.id)
            expect(page).to have_content "このトレーニーと成立した契約はありません"
          end
        end

        context "このトレーニーからの契約リクエストがある場合" do
          let!(:contract) { create(:contract, trainee_id: trainee.id, trainer_id: trainer.id, final_decision: false) }

          scenario "「このトレーニーからリクエストされた契約」と表示されること" do
            visit trainee_path(trainee.id)
            expect(page).to have_content "このトレーニーからリクエストされた契約"
          end

          scenario "「この契約リクエストの詳細を見る」をクリックすると、契約詳細ページにリダイレクトすること" do
            visit trainee_path(trainee.id)
            click_on "この契約リクエストの詳細を見る"
            expect(current_path).to eq contract_path(contract.id)
          end
        end

        context "このトレーニーと成立した契約がある場合" do
          let!(:contract) { create(:contract, trainee_id: trainee.id, trainer_id: trainer.id, final_decision: true) }

          scenario "「このトレーニーと成立した契約」と表示されること" do
            visit trainee_path(trainee.id)
            expect(page).to have_content "このトレーニーと成立した契約"
          end

          scenario "「この契約の詳細を見る」をクリックすると、契約詳細ページにリダイレクトすること" do
            visit trainee_path(trainee.id)
            click_on "この契約の詳細を見る"
            expect(current_path).to eq contract_path(contract.id)
          end
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

    before do
      login_as_trainer trainer
    end

    scenario "トレーニー検索ページに訪れると、検索フォームがあり、トレーニーは１件も表示されていないこと" do
      visit search_for_trainee_path
      aggregate_failures do
        expect(current_path).to eq search_for_trainee_path
        expect(page).to have_selector "#collapseSearch"
        expect(page).not_to have_selector "ul.search-result"
        expect(page).not_to have_content(trainee1.name)
      end
    end

    context "検索条件を入力しない場合" do
      scenario "フォームに入力せず「この条件で検索する」ボタンをクリックすると、トレーニーを全件取得すること" do
        visit search_for_trainee_path
        click_button "この条件で検索する"
        aggregate_failures do
          expect(current_path).to eq search_for_trainee_path
          expect(page).to have_selector "#collapseSearch"
          expect(page).to have_selector "div.search-result", count: 4
          expect(page).to have_content(trainee1.name)
          expect(page).to have_content(trainee2.name)
          expect(page).to have_content(trainee3.name)
          expect(page).to have_content(trainee4.name)
        end
      end

      scenario "「検索条件・検索結果をリセットする」ボタンをクリックすると、同じページにリダイレクトすること" do
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
end
