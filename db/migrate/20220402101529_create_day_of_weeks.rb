class CreateDayOfWeeks < ActiveRecord::Migration[6.1]
  def change
    create_table :day_of_weeks do |t|
      t.string :name, null: false
    end
  end
end
