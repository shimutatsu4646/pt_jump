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
class Candidate < ApplicationRecord
  belongs_to :trainee
  belongs_to :trainer

  validates :trainee_id, presence: true
  validates :trainer_id, presence: true
end
