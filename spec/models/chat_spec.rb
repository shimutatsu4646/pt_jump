# == Schema Information
#
# Table name: chats
#
#  id           :bigint           not null, primary key
#  content      :text(65535)      not null
#  from_trainee :boolean          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  trainee_id   :bigint           not null
#  trainer_id   :bigint           not null
#
# Indexes
#
#  index_chats_on_trainee_id  (trainee_id)
#  index_chats_on_trainer_id  (trainer_id)
#
# Foreign Keys
#
#  fk_rails_...  (trainee_id => trainees.id)
#  fk_rails_...  (trainer_id => trainers.id)
#
require 'rails_helper'

RSpec.describe Chat, type: :model do
  describe "バリデーション" do
    let!(:trainee) { create(:trainee) }
    let!(:trainer) { create(:trainer) }

    it "全てのカラムに入力値がある場合、有効となること" do
      chat = build(:chat, content: "hello", trainee_id: trainee.id, trainer_id: trainer.id, from_trainee: true)
      expect(chat).to be_valid
    end

    describe "content" do
      it "contentがnilである場合、無効になること" do
        chat = build(:chat, content: nil, trainee_id: trainee.id, trainer_id: trainer.id, from_trainee: true)
        expect(chat).to be_invalid
      end
    end

    describe "trainee_id" do
      it "trainee_idがnilである場合、無効になること" do
        chat = build(:chat, content: "hello", trainee_id: nil, trainer_id: trainer.id, from_trainee: true)
        expect(chat).to be_invalid
      end
    end

    describe "traner_id" do
      it "trainer_idがnilである場合、無効になること" do
        chat = build(:chat, content: "hello", trainee_id: trainee.id, trainer_id: nil, from_trainee: true)
        expect(chat).to be_invalid
      end
    end

    describe "from_trainee" do
      it "from_traineeがnilである場合、無効になること" do
        chat = build(:chat, content: "hello", trainee_id: trainee.id, trainer_id: trainer.id, from_trainee: nil)
        expect(chat).to be_invalid
      end

      it "from_traineeがtrueである場合、有効になること" do
        chat = build(:chat, content: "hello", trainee_id: trainee.id, trainer_id: trainer.id, from_trainee: true)
        expect(chat).to be_valid
      end

      it "from_traineeがfalseである場合、有効になること" do
        chat = build(:chat, content: "hello", trainee_id: trainee.id, trainer_id: trainer.id, from_trainee: false)
        expect(chat).to be_valid
      end
    end
  end
end
