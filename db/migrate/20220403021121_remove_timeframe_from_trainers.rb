class RemoveTimeframeFromTrainers < ActiveRecord::Migration[6.1]
  def change
    remove_column :trainers, :timeframe, :text
  end
end
