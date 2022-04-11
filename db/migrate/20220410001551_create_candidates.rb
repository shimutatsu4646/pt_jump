class CreateCandidates < ActiveRecord::Migration[6.1]
  def change
    create_table :candidates do |t|
      t.references :trainee, foreign_key: true, null: false
      t.references :trainer, foreign_key: true, null: false
      t.timestamps
    end

    add_index :candidates, [:trainee_id, :trainer_id], unique: true
  end
end
