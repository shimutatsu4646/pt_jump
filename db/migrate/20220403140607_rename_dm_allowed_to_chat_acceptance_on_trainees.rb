class RenameDmAllowedToChatAcceptanceOnTrainees < ActiveRecord::Migration[6.1]
  def change
    rename_column :trainees, :dm_allowed, :chat_acceptance
  end
end
