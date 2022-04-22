class CreateChats < ActiveRecord::Migration[6.1]
  def change
    create_table :chats do |t|
      t.references :trainee, null: false, foreign_key: true
      t.references :trainer, null: false, foreign_key: true
      # from_traineeはチャットを送信したユーザーを判別するカラム。
      # trueのときはtraineeが、falseのときはtrainerが送信者として判断する。
      t.boolean :from_trainee, null: false
      t.text :content, null: false
      t.timestamps
    end
  end
end
