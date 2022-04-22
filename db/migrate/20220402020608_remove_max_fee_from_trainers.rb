class RemoveMaxFeeFromTrainers < ActiveRecord::Migration[6.1]
  def change
    remove_column :trainers, :max_fee, :integer
  end
end
