# == Schema Information
#
# Table name: trainees
#
#  id                     :bigint           not null, primary key
#  age                    :integer          not null
#  dm_allowed             :boolean          default(FALSE), not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  gender                 :integer          not null
#  introduction           :text(65535)
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
#  index_trainees_on_email                 (email) UNIQUE
#  index_trainees_on_reset_password_token  (reset_password_token) UNIQUE
#
FactoryBot.define do
  factory :trainee do
    name { "test_trainee" }
    age { 20 }
    gender { "male" } # 数値（0もしくは1）だと、パラメータとしてgenderデータをpostしたときに問題が発生する
    timeframe { "" }
    introduction { "" }
    dm_allowed { false }
    sequence(:email) { |n| "test_trainee#{n}@example.com" }
    password { "trainee_password" }
    password_confirmation { 'trainee_password' }
  end
end
