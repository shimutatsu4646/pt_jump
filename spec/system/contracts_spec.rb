require 'rails_helper'

RSpec.describe "Contracts System", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "契約一覧ページ" do
    context "トレーニーとしてログインしている場合" do
      let!(:trainee) { create(:trainee) }
      let!(:trainer1) { create(:trainer, name: "trainer1") }
      let!(:trainer2) { create(:trainer, name: "trainer2") }
      let!(:trainer3) { create(:trainer, name: "trainer3") }
      let!(:trainer4) { create(:trainer, name: "trainer4") }

      let!(:contract1) do
        create(:contract,
        trainee_id: trainee.id,
        trainer_id: trainer1.id,
        final_decision: false)
      end
      let!(:contract2) do
        create(:contract,
        trainee_id: trainee.id,
        trainer_id: trainer2.id,
        final_decision: false)
      end
      let!(:contract3) do
        create(:contract,
        trainee_id: trainee.id,
        trainer_id: trainer3.id,
        final_decision: true)
      end

      before do
        login_as_trainee trainee
      end

      scenario "契約リクエストしたトレーナーと、契約成立したトレーナーが表示されていること" do
        visit contracts_path
        aggregate_failures do
          expect(page).to have_content "trainer1"
          expect(page).to have_content "trainer2"
          expect(page).to have_content "trainer3"
          expect(page).not_to have_content "trainer4"
        end
      end

      scenario "契約リクエスト・成立済み契約の詳細ページへのリンクが契約数と同じ数だけ表示されていること" do
        visit contracts_path
        aggregate_failures do
          expect(page).to have_link "この契約リクエストの詳細を見る", count: 2
          expect(page).to have_link "この契約の詳細を見る", count: 1
        end
      end
    end

    context "トレーナーとしてログインしている場合" do
      let!(:trainer) { create(:trainer) }
      let!(:trainee1) { create(:trainee, name: "trainee1") }
      let!(:trainee2) { create(:trainee, name: "trainee2") }
      let!(:trainee3) { create(:trainee, name: "trainee3") }
      let!(:trainee4) { create(:trainee, name: "trainee4") }

      let!(:contract1) do
        create(:contract,
        trainee_id: trainee1.id,
        trainer_id: trainer.id,
        final_decision: false)
      end
      let!(:contract2) do
        create(:contract,
        trainee_id: trainee2.id,
        trainer_id: trainer.id,
        final_decision: false)
      end
      let!(:contract3) do
        create(:contract,
        trainee_id: trainee3.id,
        trainer_id: trainer.id,
        final_decision: true)
      end

      before do
        login_as_trainer trainer
      end

      scenario "契約リクエストしたトレーナーと、契約成立したトレーナーが表示されていること" do
        visit contracts_path
        aggregate_failures do
          expect(page).to have_content "trainee1"
          expect(page).to have_content "trainee2"
          expect(page).to have_content "trainee3"
          expect(page).not_to have_content "trainee4"
        end
      end

      scenario "契約リクエスト・成立済み契約の詳細ページへのリンクが契約数と同じ数だけ表示されていること" do
        visit contracts_path
        aggregate_failures do
          expect(page).to have_link "この契約リクエストの詳細を見る", count: 2
          expect(page).to have_link "この契約の詳細を見る", count: 1
        end
      end
    end
  end

  describe "契約詳細ページ" do
    describe "未成立の契約" do
      context "トレー二ーとしてログインしている場合" do
        let!(:trainee) { create(:trainee) }
        let!(:trainer) { create(:trainer, name: "trainer_not_decide") }

        let!(:contract) do
          create(:contract,
          trainee_id: trainee.id,
          trainer_id: trainer.id,
          final_decision: false)
        end

        before do
          login_as_trainee trainee
        end

        scenario "契約相手のトレーナー名が表示されていること" do
          visit contract_path(contract.id)
          expect(page).to have_content(trainer.name)
        end

        scenario "契約の開始日・終了日が表示されていること" do
          visit contract_path(contract.id)
          expect(page).to have_content(contract.start_date.strftime("%Y年%m月%d日"))
          expect(page).to have_content(contract.end_date.strftime("%Y年%m月%d日"))
        end

        scenario "「このトレーナーの詳細ページ」をクリックするとトレーナー詳細ページにリダイレクトすること" do
          visit contract_path(contract.id)
          click_on "このトレーナーの詳細ページ"
          expect(current_path).to eq trainer_path(trainer.id)
        end

        scenario "「このトレーナーとのチャットページ」をクリックするとチャットページにリダイレクトすること" do
          visit contract_path(contract.id)
          click_on "このトレーナーとのチャットページ"
          expect(current_path).to eq chat_path(trainer.id)
        end

        describe "契約リクエスト取り消し" do
          scenario "「このリクエストを取り消す」ボタンをクリックすると契約が取り消され、契約一覧ページにリダイレクトすること" do
            visit contract_path(contract.id)
            expect do
              click_on "このリクエストを取り消す"
            end.to change { Contract.count }.by(-1)
            expect(current_path).to eq contracts_path
          end
        end

        describe "契約成立" do
          scenario "「契約成立」ボタンが存在しないこと" do
            visit contract_path(contract.id)
            expect(page).not_to have_link "契約成立"
          end
        end
      end

      context "トレーナーとしてログインしている場合" do
        let!(:trainee) { create(:trainee, name: "trainer_request_contract") }
        let!(:trainer) { create(:trainer) }

        let!(:contract) do
          create(:contract,
          trainee_id: trainee.id,
          trainer_id: trainer.id,
          final_decision: false)
        end

        before do
          login_as_trainer trainer
        end

        scenario "契約相手のトレー二ー名が表示されていること" do
          visit contract_path(contract.id)
          expect(page).to have_content(trainee.name)
        end

        scenario "契約の開始日・終了日が表示されていること" do
          visit contract_path(contract.id)
          expect(page).to have_content(contract.start_date.strftime("%Y年%m月%d日"))
          expect(page).to have_content(contract.end_date.strftime("%Y年%m月%d日"))
        end

        scenario "「このトレー二ーの詳細ページ」をクリックするとトレーニー詳細ページにリダイレクトすること" do
          visit contract_path(contract.id)
          click_on "このトレー二ーの詳細ページ"
          expect(current_path).to eq trainee_path(trainee.id)
        end

        scenario "「このトレー二ーとのチャットページ」をクリックするとチャットページにリダイレクトすること" do
          visit contract_path(contract.id)
          click_on "このトレー二ーとのチャットページ"
          expect(current_path).to eq chat_path(trainee.id)
        end

        describe "契約取り消し" do
          scenario "「このリクエストを取り消す」ボタンがそんざいしないこと" do
            visit contract_path(contract.id)
            expect(page).not_to have_link "このリクエストを取り消す"
          end
        end

        describe "契約成立" do
          scenario "「契約成立」ボタンをクリックするとfinal_dicisionがtrueとなり、契約一覧ページにリダイレクトすること" do
            visit contract_path(contract.id)
            click_on "契約成立"
            expect(contract.reload.final_decision).to eq true
            expect(current_path).to eq contracts_path
          end
        end
      end
    end

    describe "成立済みの契約" do
      context "トレー二ーとしてログインしている場合" do
        let!(:trainee) { create(:trainee) }
        let!(:trainer) { create(:trainer, name: "trainer_not_decide") }

        let!(:contract) do
          create(:contract,
          trainee_id: trainee.id,
          trainer_id: trainer.id,
          final_decision: true)
        end

        before do
          login_as_trainee trainee
        end

        scenario "契約相手のトレーナー名が表示されていること" do
          visit contract_path(contract.id)
          expect(page).to have_content(trainer.name)
        end

        scenario "契約の開始日・終了日が表示されていること" do
          visit contract_path(contract.id)
          expect(page).to have_content(contract.start_date.strftime("%Y年%m月%d日"))
          expect(page).to have_content(contract.end_date.strftime("%Y年%m月%d日"))
        end

        scenario "「このトレーナーの詳細ページ」をクリックするとトレーナー詳細ページにリダイレクトすること" do
          visit contract_path(contract.id)
          click_on "このトレーナーの詳細ページ"
          expect(current_path).to eq trainer_path(trainer.id)
        end

        scenario "「このトレーナーとのチャットページ」をクリックするとチャットページにリダイレクトすること" do
          visit contract_path(contract.id)
          click_on "このトレーナーとのチャットページ"
          expect(current_path).to eq chat_path(trainer.id)
        end

        scenario "「このリクエストを取り消す」ボタンがそんざいしないこと" do
          visit contract_path(contract.id)
          expect(page).not_to have_link "このリクエストを取り消す"
        end
      end

      context "トレーナーとしてログインしている場合" do
        let!(:trainee) { create(:trainee, name: "trainer_request_contract") }
        let!(:trainer) { create(:trainer) }

        let!(:contract) do
          create(:contract,
          trainee_id: trainee.id,
          trainer_id: trainer.id,
          final_decision: true)
        end

        before do
          login_as_trainer trainer
        end

        scenario "契約相手のトレー二ー名が表示されていること" do
          visit contract_path(contract.id)
          expect(page).to have_content(trainee.name)
        end

        scenario "契約の開始日・終了日が表示されていること" do
          visit contract_path(contract.id)
          expect(page).to have_content(contract.start_date.strftime("%Y年%m月%d日"))
          expect(page).to have_content(contract.end_date.strftime("%Y年%m月%d日"))
        end

        scenario "「このトレー二ーの詳細ページ」をクリックするとトレーニー詳細ページにリダイレクトすること" do
          visit contract_path(contract.id)
          click_on "このトレー二ーの詳細ページ"
          expect(current_path).to eq trainee_path(trainee.id)
        end

        scenario "「このトレー二ーとのチャットページ」をクリックするとチャットページにリダイレクトすること" do
          visit contract_path(contract.id)
          click_on "このトレー二ーとのチャットページ"
          expect(current_path).to eq chat_path(trainee.id)
        end

        scenario "「契約取り消し」ボタンがそんざいしないこと" do
          visit contract_path(contract.id)
          expect(page).not_to have_link "契約取り消し"
        end
      end
    end
  end

  describe "契約リクエスト作成ページ" do
    let(:trainee) { create(:trainee) }
    let(:trainer) { create(:trainer) }

    before do
      login_as_trainee trainee
    end

    context "入力に問題がない場合" do
      scenario "入力した日付の指導開始日・終了日で、且つfinal_dicisionがfalseの契約が生成されること" do
        expect(trainee.contracts.first.present?).to be_falsey

        visit new_contract_path(trainer.id)
        fill_in "contract_start_date", with: Date.current
        fill_in "contract_end_date", with: Date.current + 30
        click_on "契約のリクエストをする"
        aggregate_failures do
          expect(trainee.contracts.first.present?).to be_truthy
          expect(trainee.contracts.first.start_date).to eq Date.current
          expect(trainee.contracts.first.end_date).to eq Date.current + 30
          expect(trainee.contracts.first.final_decision).to eq false
        end
      end
    end

    context "入力に問題がある場合" do
      scenario "指導開始日のフォームに入力せず送信すると契約は生成されず、契約リクエストページ（同じページ）に戻ること" do
        expect(trainee.contracts.first.present?).to be_falsey

        visit new_contract_path(trainer.id)
        fill_in "contract_start_date", with: nil
        fill_in "contract_end_date", with: Date.current + 30
        click_on "契約のリクエストをする"
        aggregate_failures do
          expect(trainee.contracts.first.present?).to be_falsey
          expect(current_path).to eq new_contract_path(trainer.id)
        end
      end
      scenario "指導終了日のフォームに入力せず送信すると契約は生成されず、契約リクエストページ（同じページ）に戻ること" do
        expect(trainee.contracts.first.present?).to be_falsey

        visit new_contract_path(trainer.id)
        fill_in "contract_start_date", with: Date.current
        fill_in "contract_end_date", with: nil
        click_on "契約のリクエストをする"
        aggregate_failures do
          expect(trainee.contracts.first.present?).to be_falsey
          expect(current_path).to eq new_contract_path(trainer.id)
        end
      end
    end
  end
end
