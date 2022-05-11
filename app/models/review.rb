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
class Review < ApplicationRecord
  validates :trainee_id, presence: true
  validates :trainer_id, presence: true
  validates :star_rate, presence: true
  validates :star_rate, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }, allow_nil: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :comment, presence: true

  belongs_to :trainee
  belongs_to :trainer
end
