class CreateContracts < ActiveRecord::Migration[6.1]
  def change
    create_table :contracts do |t|
      t.references :trainee, foreign_key: true, null: false
      t.references :trainer, foreign_key: true, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.boolean :final_decision, null: false
      t.timestamps
    end
  end
end
