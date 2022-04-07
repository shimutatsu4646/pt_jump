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

FactoryBot.define do
  factory :chat do
    # content { "hello" }
    # trainee_id { 1 }
    # trainer_id { 1 }
    # from_trainee { true }
  end
end
