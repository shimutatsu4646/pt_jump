# == Schema Information
#
# Table name: availability_schedules
#
#  id             :bigint           not null, primary key
#  day_of_week_id :bigint           not null
#  trainee_id     :bigint           not null
#
# Indexes
#
#  index_availability_schedules_on_day_of_week_id                 (day_of_week_id)
#  index_availability_schedules_on_trainee_id_and_day_of_week_id  (trainee_id,day_of_week_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (day_of_week_id => day_of_weeks.id)
#  fk_rails_...  (trainee_id => trainees.id)
#
class AvailabilitySchedule < ApplicationRecord
  belongs_to :trainee
  belongs_to :day_of_week
end
