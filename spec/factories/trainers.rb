# == Schema Information
#
# Table name: trainers
#
#  id                     :bigint           not null, primary key
#  age                    :integer          not null
#  category               :integer
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  gender                 :integer          not null
#  instruction_method     :integer
#  instruction_period     :integer
#  introduction           :text(65535)
#  min_fee                :integer
#  name                   :string(255)      not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
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
    gender { "male" }
    introduction { nil }
    category { nil }
    instruction_method { nil }
    min_fee { nil }
    instruction_period { nil }
    sequence(:email) { |n| "test_trainer#{n}@example.com" }
    password { "trainer_password" }
    password_confirmation { "trainer_password" }

    before(:create) do |trainer|
      # デフォルトのプロフィール画像をActiveStorageで添付する。
      avatar_file = "default_trainer_avatar.png"
      avatar_path = Rails.root.join('app', 'assets', 'images', avatar_file)
      trainer.avatar.attach(io: File.open(avatar_path), filename: avatar_file)
    end
  end
end
