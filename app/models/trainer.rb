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
class Trainer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable

  devise :validatable, password_length: 8..128 # パスワードの最小文字数を８文字に変更
  validates :name, presence: true
  validates :age, presence: true
  validates :age, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :gender, presence: true
  enum gender: { male: 0, female: 1 }
  validates :instruction_period, presence: true
  enum instruction_period: { unspecified: 0, below_one_month: 1, above_one_month: 2 }

  has_one_attached :avatar
end
