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
FactoryBot.define do
  factory :contract do
    trainee_id {}
    trainer_id {}
    start_date { Date.current }
    end_date { Date.current + 30 }
    final_decision { false }
  end
end
