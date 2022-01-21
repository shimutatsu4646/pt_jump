# == Schema Information
#
# Table name: trainees
#
#  id                     :bigint           not null, primary key
#  age                    :integer          not null
#  dm_allowed             :boolean          default(FALSE), not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  end_time               :time
#  gender                 :integer          not null
#  introduction           :text(65535)
#  name                   :string(255)      not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  start_time             :time
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
    name { "test_user" }
    age { 20 }
    gender { 0 }
    email { "test@example.com" }
    password { "trainee_pass" }
    password_confirmation { 'trainee_pass' }
  end
end
