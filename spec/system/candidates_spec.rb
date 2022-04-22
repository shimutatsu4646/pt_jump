require 'rails_helper'

RSpec.describe "Candidates System", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "トレーナー候補一覧ページ" do
    let!(:trainee) { create(:trainee) }
    let!(:trainer1) { create(:trainer, name: "trainer1") }
    let!(:trainer2) { create(:trainer, name: "trainer2") }
    let!(:trainer3) { create(:trainer, name: "trainer3") }
    let!(:trainer4) { create(:trainer, name: "trainer4") }

    let!(:candidate1) do
      create(:candidate,
      trainee_id: trainee.id,
      trainer_id: trainer1.id)
    end
    let!(:candidate2) do
      create(:candidate,
      trainee_id: trainee.id,
      trainer_id: trainer2.id)
    end
    let!(:candidate3) do
      create(:candidate,
      trainee_id: trainee.id,
      trainer_id: trainer3.id)
    end

    before do
      login_as_trainee trainee
    end

    scenario "トレーナー候補として登録したトレーナーが表示されていること" do
      visit candidates_path
      aggregate_failures do
        expect(page).to have_content "trainer1"
        expect(page).to have_content "trainer2"
        expect(page).to have_content "trainer3"
        expect(page).not_to have_content "trainer4"
      end
    end

    scenario "トレーナー候補と同じ数の「このトレーナー詳細を見る」ボタンが表示されていること" do
      visit candidates_path
      expect(page).to have_button "このトレーナー詳細を見る", count: 3
    end

    scenario "トレーナー候補と同じ数の「トレーナー候補から取り消す」ボタンが表示されていること" do
      visit candidates_path
      expect(page).to have_button "トレーナー候補から取り消す", count: 3
    end

    scenario "「トレーナー候補から取り消す」ボタンをクリックすると、そのトレーナー候補データのみが削除されること" do
      visit candidates_path
      within(:css, "#candidate_#{trainer1.id}") do
        click_on "トレーナー候補から取り消す"
      end
      aggregate_failures do
        expect(trainee.candidates.reload).not_to include candidate1
        expect(trainee.candidates.reload).to include candidate2
        expect(trainee.candidates.reload).to include candidate3
      end
    end
  end
end
