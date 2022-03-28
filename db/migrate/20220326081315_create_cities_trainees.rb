class CreateCitiesTrainees < ActiveRecord::Migration[6.1]
  def change
    create_table :cities_trainees do |t|
      t.references :trainee, foreign_key: true, null: false, index: false
      t.references :city, foreign_key: true, null: false
    end

    add_index :cities_trainees, [:trainee_id, :city_id], unique: true
  end
end
