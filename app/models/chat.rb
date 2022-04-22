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
class Chat < ApplicationRecord
  belongs_to :trainee
  belongs_to :trainer

  validates :content, presence: true
  validates :trainee_id, presence: true
  validates :trainer_id, presence: true
  validates :from_trainee, inclusion: { in: [true, false] }
end
