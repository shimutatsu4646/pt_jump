class CreateAvailabilitySchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :availability_schedules do |t|
      t.references :trainee, foreign_key: true, null: false, index: false
      t.references :day_of_week, foreign_key: true, null: false
    end

    add_index :availability_schedules, [:trainee_id, :day_of_week_id], unique: true
  end
end
