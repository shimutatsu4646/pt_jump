class AddColumnsToTrainees < ActiveRecord::Migration[6.1]
  def change
    add_column :trainees, :category, :integer
    add_column :trainees, :instruction_method, :integer
  end
end
