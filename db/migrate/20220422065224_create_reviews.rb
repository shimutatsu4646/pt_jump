class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.references :trainee, foreign_key: true
      t.references :trainer, null: false, foreign_key: true
      t.float :star_rate, null: false, default: 0
      t.string :title, null: false
      t.text :comment, null: false

      t.timestamps
    end
  end
end
