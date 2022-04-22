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
class Contract < ApplicationRecord
  belongs_to :trainee
  belongs_to :trainer

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :final_decision, inclusion: { in: [true, false] }

  validate :date_before_start
  validate :date_before_end

  private

  def date_before_start
    return if start_date.blank?
    errors.add(:start_date, "は今日以降のものを選択してください") if start_date < Date.current
  end

  def date_before_end
    return if start_date.blank?
    return if end_date.blank?
    errors.add(:end_date, "は開始日以降のものを選択してください") if end_date <= start_date
  end
end
