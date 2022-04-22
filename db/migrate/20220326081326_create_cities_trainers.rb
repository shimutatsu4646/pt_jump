class CreateCitiesTrainers < ActiveRecord::Migration[6.1]
  def change
    create_table :cities_trainers do |t|
      t.references :trainer, foreign_key: true, null: false, index: false
      t.references :city, foreign_key: true, null: false
    end

    add_index :cities_trainers, [:trainer_id, :city_id], unique: true
  end
end
