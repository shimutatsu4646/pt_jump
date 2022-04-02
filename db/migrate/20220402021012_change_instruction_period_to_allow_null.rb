class ChangeInstructionPeriodToAllowNull < ActiveRecord::Migration[6.1]
  def change
    change_column_default :trainers, :instruction_period, from: 0, to: nil
    change_column_null :trainers, :instruction_period, true
  end
end
