# == Schema Information
#
# Table name: instruction_schedules
#
#  id             :bigint           not null, primary key
#  day_of_week_id :bigint           not null
#  trainer_id     :bigint           not null
#
# Indexes
#
#  index_instruction_schedules_on_day_of_week_id                 (day_of_week_id)
#  index_instruction_schedules_on_trainer_id_and_day_of_week_id  (trainer_id,day_of_week_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (day_of_week_id => day_of_weeks.id)
#  fk_rails_...  (trainer_id => trainers.id)
#
class InstructionSchedule < ApplicationRecord
  belongs_to :trainer
  belongs_to :day_of_week
end
