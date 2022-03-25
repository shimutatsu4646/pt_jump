class AddColumnsToTrainers < ActiveRecord::Migration[6.1]
  def change
    add_column :trainers, :category, :integer
    add_column :trainers, :instruction_method, :integer
  end
end
