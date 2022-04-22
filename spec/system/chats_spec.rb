require 'rails_helper'

RSpec.describe "Chats System", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "チャット一覧ページ" do
    context "トレーニーとしてログインしている場合" do
      let!(:trainee) { create(:trainee) }
      let!(:trainer1) { create(:trainer, name: "trainer1") }
      let!(:trainer2) { create(:trainer, name: "trainer2") }
      let!(:trainer3) { create(:trainer, name: "trainer3") }

      let!(:chat1_1) do
        create(:chat,
        content: "trainer1 first", from_trainee: true,
        trainee_id: trainee.id, trainer_id: trainer1.id)
      end
      let!(:chat1_2) do
        create(:chat,
        content: "trainer1 last", from_trainee: true,
        trainee_id: trainee.id, trainer_id: trainer1.id)
      end
      let!(:chat2) do
        create(:chat,
        content: "trainer2 first and last content", from_trainee: false,
        trainee_id: trainee.id, trainer_id: trainer2.id)
      end

      before do
        login_as_trainee trainee
      end

      scenario "チャットをしているトレーナーの名前が表示されていること" do
        visit chats_path
        aggregate_failures do
          expect(page).to have_content "trainer1"
          expect(page).to have_content "trainer2"
          expect(page).not_to have_content "trainer3"
        end
      end

      scenario "チャットをしているトレーナーと同じ数の「チャットページ」リンクが表示されていること" do
        visit chats_path
        expect(page).to have_link "チャットページ", count: 2
      end

      scenario "画像の数がチャットをしているトレーナーと同じ数になっていること" do
        visit chats_path
        within(:css, ".chat-partners") do
          expect(page).to have_selector "img", count: 2
        end
      end

      scenario "トレーナーとの最後のチャットのみが表示されていること" do
        visit chats_path
        aggregate_failures do
          expect(page).not_to have_content "trainer1 first"
          expect(page).to have_content "trainer1 last"
        end
      end

      scenario "チャットのcontentが20文字を超える場合は切り捨てられ、最後の3文字が...となること" do
        visit chats_path
        expect(page).to have_content "trainer2 first an..."
        # 本来のcontentは "trainer2 first and last content" である。
      end
    end

    context "トレーナーとしてログインしている場合" do
      let!(:trainer) { create(:trainer) }
      let!(:trainee1) { create(:trainee, name: "trainee1") }
      let!(:trainee2) { create(:trainee, name: "trainee2") }
      let!(:trainee3) { create(:trainee, name: "trainee3") }

      let!(:chat1_1) do
        create(:chat,
        content: "trainee1 first", from_trainee: true,
        trainer_id: trainer.id, trainee_id: trainee1.id)
      end
      let!(:chat1_2) do
        create(:chat,
        content: "trainee1 last", from_trainee: true,
        trainer_id: trainer.id, trainee_id: trainee1.id)
      end
      let!(:chat2) do
        create(:chat,
        content: "trainee2 first and last content", from_trainee: false,
        trainer_id: trainer.id, trainee_id: trainee2.id)
      end

      before do
        login_as_trainer trainer
      end

      scenario "チャットをしているトレーニーの名前が表示されていること" do
        visit chats_path
        aggregate_failures do
          expect(page).to have_content "trainee1"
          expect(page).to have_content "trainee2"
          expect(page).not_to have_content "trainee3"
        end
      end

      scenario "チャットをしているトレーニーと同じ数の「チャットページ」リンクが表示されていること" do
        visit chats_path
        expect(page).to have_link "チャットページ", count: 2
      end

      scenario "画像の数がチャットをしているトレーニーと同じ数になっていること" do
        visit chats_path
        within(:css, ".chat-partners") do
          expect(page).to have_selector "img", count: 2
        end
      end

      scenario "トレーニーとの最後のチャットのみが表示されていること" do
        visit chats_path
        aggregate_failures do
          expect(page).not_to have_content "trainee1 first"
          expect(page).to have_content "trainee1 last"
        end
      end

      scenario "チャットのcontentが20文字を超える場合は切り捨てられ、最後の3文字が...となること" do
        visit chats_path
        expect(page).to have_content "trainee2 first an..."
        # 本来のcontentは "trainee2 first and last content" である。
      end
    end
  end

  describe "チャットページ" do
    context "トレーニーとしてログインしている場合" do
      let!(:trainee) { create(:trainee) }
      let!(:trainer) { create(:trainer, name: "chat_trainer") }

      let!(:chat1) do
        create(:chat,
        content: "first content", from_trainee: true,
        trainee_id: trainee.id, trainer_id: trainer.id)
      end
      let!(:chat2) do
        create(:chat,
        content: "second content", from_trainee: false,
        trainee_id: trainee.id, trainer_id: trainer.id)
      end

      before do
        login_as_trainee trainee
      end

      scenario "ページに訪れると、相手との過去のチャットが全て表示されていること" do
        visit chat_path(trainer.id)
        aggregate_failures do
          expect(page).to have_content "first content"
          expect(page).to have_content "second content"
        end
      end

      scenario "文字を入力し、「送信」を押すとチャットが生成され、ページに表示すること" do
        visit chat_path(trainer.id)
        expect do
          fill_in "chat_content", with: "third content"
          click_on "送信"
        end.to change { Chat.count }.by(1)
        aggregate_failures do
          expect(current_path).to eq chat_path(trainer.id)
          expect(page).to have_content "first content"
          expect(page).to have_content "second content"
          expect(page).to have_content "third content"
        end
      end

      scenario "文字を入力せず、「送信」を押すとチャットは生成されず,flashが発生すること" do
        visit chat_path(trainer.id)

        expect do
          click_on "送信"
        end.not_to change { Chat.count }

        aggregate_failures do
          expect(current_path).to eq chat_path(trainer.id)
          expect(page).to have_content "何か入力してください"
        end
      end

      scenario "「チャットを更新する」を押すと、同じページにレンダリングすること" do
        visit chat_path(trainer.id)
        click_on "チャットを更新"
        expect(current_path).to eq chat_path(trainer.id)
      end

      scenario "「チャット一覧」を押すと、チャット一覧ページにレンダリングすること" do
        visit chat_path(trainer.id)
        within(:css, "main") do
          click_on "チャット一覧"
        end
        expect(current_path).to eq chats_path
      end

      scenario "「このトレーナーの詳細」を押すと、詳細ページにレンダリングすること" do
        visit chat_path(trainer.id)
        click_on "このトレーナーの詳細"
        expect(current_path).to eq trainer_path(trainer.id)
      end

      scenario "「〜さんに契約リクエストをする」を押すと、契約リクエストページにレンダリングすること" do
        visit chat_path(trainer.id)
        click_on "#{trainer.name}さんに契約リクエストをする"
        expect(current_path).to eq new_contract_path(trainer.id)
      end
    end

    context "トレーナーとしてログインしている場合" do
      let!(:trainee) { create(:trainee) }
      let!(:trainer) { create(:trainer) }

      let!(:chat1) do
        create(:chat,
        content: "first content", from_trainee: true,
        trainee_id: trainee.id, trainer_id: trainer.id)
      end
      let!(:chat2) do
        create(:chat,
        content: "second content", from_trainee: false,
        trainee_id: trainee.id, trainer_id: trainer.id)
      end

      before do
        login_as_trainer trainer
      end

      scenario "ページに訪れると、相手との過去のチャットが全て表示されていること" do
        visit chat_path(trainee.id)
        aggregate_failures do
          expect(page).to have_content "first content"
          expect(page).to have_content "second content"
        end
      end

      scenario "文字を入力し、「送信」を押すとチャットが生成され、ページに表示すること" do
        visit chat_path(trainee.id)
        expect do
          fill_in "chat_content", with: "third content"
          click_on "送信"
        end.to change { Chat.count }.by(1)
        aggregate_failures do
          expect(current_path).to eq chat_path(trainee.id)
          expect(page).to have_content "first content"
          expect(page).to have_content "second content"
          expect(page).to have_content "third content"
        end
      end

      scenario "文字を入力せず、「送信」を押すとチャットは生成されず,flashが発生すること" do
        visit chat_path(trainee.id)

        expect do
          click_on "送信"
        end.not_to change { Chat.count }

        aggregate_failures do
          expect(current_path).to eq chat_path(trainee.id)
          expect(page).to have_content "何か入力してください"
        end
      end

      scenario "「チャットを更新する」を押すと、同じページにレンダリングすること" do
        visit chat_path(trainee.id)
        click_on "チャットを更新"
        expect(current_path).to eq chat_path(trainee.id)
      end

      scenario "「チャット一覧」を押すと、チャット一覧ページにレンダリングすること" do
        visit chat_path(trainee.id)
        within(:css, "main") do
          click_on "チャット一覧"
        end
        expect(current_path).to eq chats_path
      end

      scenario "「このトレーニーの詳細」を押すと、詳細ページにレンダリングすること" do
        visit chat_path(trainee.id)
        click_on "このトレーニーの詳細"
        expect(current_path).to eq trainee_path(trainee.id)
      end

      scenario "「〜さんに契約リクエストをする」リンクがページ内に存在しないこと" do
        visit chat_path(trainer.id)
        expect(page).not_to have_content "#{trainer.name}さんに契約リクエストをする"
      end
    end
  end
end
