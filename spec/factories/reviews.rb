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
FactoryBot.define do
  factory :review do
    title { "title" }
    comment { "comment text" }
    star_rate { 5.0 }
    trainee_id {}
    trainer_id {}
  end
end
