# == Schema Information
#
# Table name: day_of_weeks
#
#  id   :bigint           not null, primary key
#  name :string(255)      not null
#
class DayOfWeek < ApplicationRecord
  has_many :availability_schedules
  has_many :instruction_schedules
  has_many :trainees, through: :availability_schedules
  has_many :trainers, through: :instruction_schedules

  validates :name, presence: true
end
