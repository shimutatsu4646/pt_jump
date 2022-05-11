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
  enum instruction_period: { below_one_month: 0, above_one_month: 1 }
  enum category: { losing_weight: 0, building_muscle: 1, physical_function: 2, physical_therapy: 3 }
  enum instruction_method: { offline: 0, online: 1 }

  has_one_attached :avatar, dependent: :destroy

  has_and_belongs_to_many :cities, dependent: :destroy
  has_many :prefectures, through: :cities

  has_many :instruction_schedules, dependent: :destroy
  has_many :day_of_weeks, through: :instruction_schedules

  has_many :chats, dependent: :destroy

  has_many :contracts, dependent: :destroy

  has_many :candidates, dependent: :destroy

  has_many :reviews, dependent: :destroy

  scope :search_trainer, -> (trainer_search_params) do
    return if trainer_search_params.blank?

    age_from(trainer_search_params[:age_from]).
      age_to(trainer_search_params[:age_to]).
      which_gender(trainer_search_params[:gender]).
      which_category(trainer_search_params[:category]).
      which_instruction_method(trainer_search_params[:instruction_method]).
      which_instruction_period(trainer_search_params[:instruction_period]).
      min_fee_from(trainer_search_params[:min_fee_from]).
      min_fee_to(trainer_search_params[:min_fee_to]).
      what_cities(trainer_search_params[:city_ids]).
      what_days_of_week(trainer_search_params[:day_of_week_ids])
  end

  scope :age_from, -> (from) {
    where("? <= age", from) if from.present?
  }
  scope :age_to, -> (to) {
    where("age <= ?", to) if to.present?
  }
  scope :which_gender, -> (gender) {
    where(gender: gender) if gender.present?
  }
  scope :which_category, -> (category) {
    where(category: category) if category.present?
  }
  scope :which_instruction_method, -> (instruction_method) {
    where(instruction_method: instruction_method) if instruction_method.present?
  }
  scope :which_instruction_period, -> (instruction_period) {
    where(instruction_period: instruction_period) if instruction_period.present?
  }
  scope :min_fee_from, -> (from) {
    where("? <= min_fee", from) if from.present?
  }
  scope :min_fee_to, -> (to) {
    where("min_fee <= ?", to) if to.present?
  }
  scope :what_cities, -> (city_ids) {
    where(cities: { id: city_ids.reject(&:blank?).map(&:to_i) }) if city_ids.reject(&:blank?).present?
  }
  scope :what_days_of_week, -> (day_of_week_ids) {
    where(day_of_weeks: { id: day_of_week_ids.reject(&:blank?).map(&:to_i) }) if day_of_week_ids.reject(&:blank?).present?
  }
end
