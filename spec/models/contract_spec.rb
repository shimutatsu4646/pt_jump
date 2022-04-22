# == Schema Information
#
# Table name: contracts
#
#  id             :bigint           not null, primary key
#  end_date       :date             not null
#  final_decision :boolean          not null
#  start_date     :date             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  trainee_id     :bigint           not null
#  trainer_id     :bigint           not null
#
# Indexes
#
#  index_contracts_on_trainee_id  (trainee_id)
#  index_contracts_on_trainer_id  (trainer_id)
#
# Foreign Keys
#
#  fk_rails_...  (trainee_id => trainees.id)
#  fk_rails_...  (trainer_id => trainers.id)
#
require 'rails_helper'

RSpec.describe Contract, type: :model do
  describe "バリデーション" do
    let!(:trainee) { create(:trainee) }
    let!(:trainer) { create(:trainer) }

    it "全てのカラムに入力値がある場合、有効となること" do
      contract = build(:contract,
        start_date: Date.current, end_date: Date.current + 31,
        trainee_id: trainee.id, trainer_id: trainer.id,
        final_decision: false)
      expect(contract).to be_valid
    end

    describe "trainee_id" do
      it "trainee_idがnilである場合、無効になること" do
        contract = build(:contract,
          start_date: Date.current + 1, end_date: Date.current + 31,
          trainee_id: nil, trainer_id: trainer.id,
          final_decision: false)
        expect(contract).to be_invalid
      end
    end

    describe "trainer_id" do
      it "trainer_idがnilである場合、無効になること" do
        contract = build(:contract,
          start_date: Date.current + 1, end_date: Date.current + 31,
          trainee_id: trainee.id, trainer_id: nil,
          final_decision: false)
        expect(contract).to be_invalid
      end
    end

    describe "start_date" do
      it "start_dateがnilである場合、無効になること" do
        contract = build(:contract,
          start_date: nil, end_date: Date.current + 31,
          trainee_id: trainee.id, trainer_id: trainer.id,
          final_decision: false)
        expect(contract).to be_invalid
      end

      it "start_dateが現在の日付と同じである場合、有効になること" do
        contract = build(:contract,
          start_date: Date.current, end_date: Date.current + 31,
          trainee_id: trainee.id, trainer_id: trainer.id,
          final_decision: false)
        expect(contract).to be_valid
      end

      it "start_dateが現在の日付よりも前の日付である場合、無効になること" do
        contract = build(:contract,
          start_date: Date.current - 1, end_date: Date.current + 31,
          trainee_id: trainee.id, trainer_id: trainer.id,
          final_decision: false)
        expect(contract).to be_invalid
      end

      it "start_dateが現在の日付よりも後の日付である場合、有効になること" do
        contract = build(:contract,
          start_date: Date.current + 1, end_date: Date.current + 31,
          trainee_id: trainee.id, trainer_id: trainer.id,
          final_decision: false)
        expect(contract).to be_valid
      end
    end

    describe "end_date" do
      it "end_dateがnilである場合、無効になること" do
        contract = build(:contract,
          start_date: Date.current, end_date: nil,
          trainee_id: trainee.id, trainer_id: trainer.id,
          final_decision: false)
        expect(contract).to be_invalid
      end

      it "end_dateがstart_dateの日付と同じである場合、無効になること" do
        contract = build(:contract,
          start_date: Date.current + 1, end_date: Date.current + 1,
          trainee_id: trainee.id, trainer_id: trainer.id,
          final_decision: false)
        expect(contract).to be_invalid
      end

      it "end_dateがstart_dateよりも前の日付である場合、無効になること" do
        contract = build(:contract,
          start_date: Date.current + 2, end_date: Date.current + 1,
          trainee_id: trainee.id, trainer_id: trainer.id,
          final_decision: false)
        expect(contract).to be_invalid
      end

      it "end_dateがstart_dateよりも後の日付である場合、有効になること" do
        contract = build(:contract,
          start_date: Date.current + 1, end_date: Date.current + 2,
          trainee_id: trainee.id, trainer_id: trainer.id,
          final_decision: false)
        expect(contract).to be_valid
      end
    end

    describe "final_decision" do
      it "final_decisionがnilである場合、無効になること" do
        contract = build(:contract,
          start_date: Date.current, end_date: Date.current + 31,
          trainee_id: trainee.id, trainer_id: trainer.id,
          final_decision: nil)
        expect(contract).to be_invalid
      end

      it "final_decisionがtrueである場合、有効になること" do
        contract = build(:contract,
          start_date: Date.current, end_date: Date.current + 31,
          trainee_id: trainee.id, trainer_id: trainer.id,
          final_decision: true)
        expect(contract).to be_valid
      end

      it "final_decisionがfalseである場合、有効になること" do
        contract = build(:contract,
          start_date: Date.current, end_date: Date.current + 31,
          trainee_id: trainee.id, trainer_id: trainer.id,
          final_decision: false)
        expect(contract).to be_valid
      end
    end
  end
end
