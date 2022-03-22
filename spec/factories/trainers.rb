# == Schema Information
#
# Table name: trainers
#
#  id                     :bigint           not null, primary key
#  age                    :integer          not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  gender                 :integer          not null
#  instruction_period     :integer          default("unspecified"), not null
#  introduction           :text(65535)
#  max_fee                :integer
#  min_fee                :integer
#  name                   :string(255)      not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  timeframe              :text(65535)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_trainers_on_email                 (email) UNIQUE
#  index_trainers_on_reset_password_token  (reset_password_token) UNIQUE
#
FactoryBot.define do
  factory :trainer do
    name { "test_trainer" }
    age { 20 }
    gender { "male" } # 数値（0もしくは1）だと、パラメータとしてgenderデータをpostしたときに問題が発生する
    timeframe { "" }
    introduction { "" }
    min_fee { nil }
    max_fee { nil }
    instruction_period { "unspecified" }
    sequence(:email) { |n| "test_trainer#{n}@example.com" }
    password { "trainer_password" }
    password_confirmation { 'trainer_password' }

    before(:create) do |trainer|
      # デフォルトのプロフィール画像をActiveStorageで添付する。
      avatar_file = "default_trainer_avatar.png"
      avatar_path = Rails.root.join('app', 'assets', 'images', avatar_file)
      trainer.avatar.attach(io: File.open(avatar_path), filename: avatar_file)
    end
  end
end
