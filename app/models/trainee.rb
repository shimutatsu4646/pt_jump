# == Schema Information
#
# Table name: trainees
#
#  id                     :bigint           not null, primary key
#  age                    :integer          not null
#  category               :integer
#  dm_allowed             :boolean          default(FALSE), not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  gender                 :integer          not null
#  instruction_method     :integer
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
class Trainee < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable

  devise :validatable, password_length: 8..128 # パスワードの最小文字数を８文字に変更
  validates :name, presence: true
  validates :age, presence: true
  validates :age, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :gender, presence: true
  enum gender: { male: 0, female: 1 }
  validates :dm_allowed, inclusion: { in: [true, false] }
  enum category: { losing_weight: 0, building_muscle: 1, physical_function: 2, physical_therapy: 3 }
  enum instruction_method: { offline: 0, online: 1 }

  has_one_attached :avatar
end
