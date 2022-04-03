class RemoveTimeframeFromTrainees < ActiveRecord::Migration[6.1]
  def change
    remove_column :trainees, :timeframe, :text
  end
end
