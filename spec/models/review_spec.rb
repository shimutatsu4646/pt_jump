# == Schema Information
#
# Table name: reviews
#
#  id         :bigint           not null, primary key
#  comment    :text(65535)      not null
#  star_rate  :float(24)        default(0.0), not null
#  title      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  trainee_id :bigint
#  trainer_id :bigint           not null
#
# Indexes
#
#  index_reviews_on_trainee_id  (trainee_id)
#  index_reviews_on_trainer_id  (trainer_id)
#
# Foreign Keys
#
#  fk_rails_...  (trainee_id => trainees.id)
#  fk_rails_...  (trainer_id => trainers.id)
#
require 'rails_helper'

RSpec.describe Review, type: :model do
  describe "バリデーション" do
    let!(:trainee) { create(:trainee) }
    let!(:trainer) { create(:trainer) }

    it "全てのカラムに入力値がある場合、有効となること" do
      review = build(:review,
        title: "title", comment: "comment text", trainee_id: trainee.id, trainer_id: trainer.id, star_rate: 5.0)
      expect(review).to be_valid
    end

    describe "comment" do
      it "commentがnilである場合、無効になること" do
        review = build(:review,
          title: "title", comment: nil, trainee_id: trainee.id, trainer_id: trainer.id, star_rate: 5.0)
        expect(review).to be_invalid
      end
    end

    describe "title" do
      it "titleがnilである場合、無効になること" do
        review = build(:review,
          title: nil, comment: "comment text", trainee_id: trainee.id, trainer_id: trainer.id, star_rate: 5.0)
        expect(review).to be_invalid
      end

      it "titleが50文字である場合、有効になること" do
        review = build(:review,
           title: "a" * 50, comment: "comment text", trainee_id: trainee.id, trainer_id: trainer.id, star_rate: 5.0)
        expect(review).to be_valid
      end

      it "titleが51文字である場合、無効になること" do
        review = build(:review,
           title: "a" * 51, comment: "comment text", trainee_id: trainee.id, trainer_id: trainer.id, star_rate: 5.0)
        expect(review).to be_invalid
      end
    end

    describe "trainee_id" do
      it "trainee_idがnilである場合、無効になること" do
        review = build(:review,
          title: "title", comment: "comment text", trainee_id: nil, trainer_id: trainer.id, star_rate: 5.0)
        expect(review).to be_invalid
      end
    end

    describe "traner_id" do
      it "trainer_idがnilである場合、無効になること" do
        review = build(:review,
          title: "title", comment: "comment text", trainee_id: trainee.id, trainer_id: nil, star_rate: 5.0)
        expect(review).to be_invalid
      end
    end

    describe "star_rate" do
      it "star_rateがnilである場合、無効になること" do
        review = build(:review,
          title: "title", comment: "comment text", trainee_id: trainee.id, trainer_id: trainer.id, star_rate: nil)
        expect(review).to be_invalid
      end

      it "star_rateが0の場合、無効になること" do
        review = build(:review,
          title: "title", comment: "comment text", trainee_id: trainee.id, trainer_id: trainer.id, star_rate: 0)
        expect(review).to be_invalid
      end

      it "star_rateが1の場合、有効になること" do
        review = build(:review,
          title: "title", comment: "comment text", trainee_id: trainee.id, trainer_id: trainer.id, star_rate: 1)
        expect(review).to be_valid
      end

      it "star_rateが5である場合、有効になること" do
        review = build(:review,
          title: "title", comment: "comment text", trainee_id: trainee.id, trainer_id: trainer.id, star_rate: 5)
        expect(review).to be_valid
      end

      it "star_rateが6である場合、無効になること" do
        review = build(:review,
          title: "title", comment: "comment text", trainee_id: trainee.id, trainer_id: trainer.id, star_rate: 6)
        expect(review).to be_invalid
      end
    end
  end
end
