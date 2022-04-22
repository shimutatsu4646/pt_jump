# == Schema Information
#
# Table name: candidates
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  trainee_id :bigint           not null
#  trainer_id :bigint           not null
#
# Indexes
#
#  index_candidates_on_trainee_id                 (trainee_id)
#  index_candidates_on_trainee_id_and_trainer_id  (trainee_id,trainer_id) UNIQUE
#  index_candidates_on_trainer_id                 (trainer_id)
#
# Foreign Keys
#
#  fk_rails_...  (trainee_id => trainees.id)
#  fk_rails_...  (trainer_id => trainers.id)
#
require 'rails_helper'

RSpec.describe Candidate, type: :model do
  describe "バリデーション" do
    let(:trainee) { create(:trainee) }
    let(:trainer) { create(:trainer) }

    it "全てのカラムに入力値がある場合、有効となること" do
      candidate = build(:candidate, trainee_id: trainee.id, trainer_id: trainer.id)
      expect(candidate).to be_valid
    end

    describe "trainee_id" do
      it "trainee_idがnilである場合、無効になること" do
        candidate = build(:candidate, trainee_id: nil, trainer_id: trainer.id)
        expect(candidate).to be_invalid
      end
    end

    describe "traner_id" do
      it "trainer_idがnilである場合、無効になること" do
        candidate = build(:candidate, trainee_id: trainee.id, trainer_id: nil)
        expect(candidate).to be_invalid
      end
    end
  end
end
