class CreateInstructionSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :instruction_schedules do |t|
      t.references :trainer, foreign_key: true, null: false, index: false
      t.references :day_of_week, foreign_key: true, null: false
    end

    add_index :instruction_schedules, [:trainer_id, :day_of_week_id], unique: true
  end
end
