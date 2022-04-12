# == Schema Information
#
# Table name: trainees
#
#  id                     :bigint           not null, primary key
#  age                    :integer          not null
#  category               :integer
#  chat_acceptance        :boolean          default(FALSE), not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  gender                 :integer          not null
#  instruction_method     :integer
#  introduction           :text(65535)
#  name                   :string(255)      not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
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
  validates :chat_acceptance, inclusion: { in: [true, false] }
  enum category: { losing_weight: 0, building_muscle: 1, physical_function: 2, physical_therapy: 3 }
  enum instruction_method: { offline: 0, online: 1 }

  has_one_attached :avatar, dependent: :destroy

  has_and_belongs_to_many :cities, dependent: :destroy
  has_many :prefectures, through: :cities

  has_many :availability_schedules, dependent: :destroy
  has_many :day_of_weeks, through: :availability_schedules

  has_many :chats, dependent: :destroy

  has_many :contracts, dependent: :destroy

  has_many :candidates, dependent: :destroy
  has_many :trainer_candidates, through: :candidates, source: :trainer

  scope :search_trainee, -> (trainee_search_params) do
    return if trainee_search_params.blank?

    whether_accept_chats(trainee_search_params[:chat_acceptance]).
      age_from(trainee_search_params[:age_from]).
      age_to(trainee_search_params[:age_to]).
      which_gender(trainee_search_params[:gender]).
      which_category(trainee_search_params[:category]).
      which_instruction_method(trainee_search_params[:instruction_method]).
      what_cities(trainee_search_params[:city_ids]).
      what_days_of_week(trainee_search_params[:day_of_week_ids])
  end

  # ↓検索ページにて、チェックボックスにチェックがない場合適応しない。
  scope :whether_accept_chats, -> (chat_acceptance) {
    where(chat_acceptance: chat_acceptance) if chat_acceptance == "1"
  }
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
  scope :what_cities, -> (city_ids) {
    where(cities: { id: city_ids.reject(&:blank?).map(&:to_i) }) if city_ids.reject(&:blank?).present?
  }
  scope :what_days_of_week, -> (day_of_week_ids) {
    where(day_of_weeks: { id: day_of_week_ids.reject(&:blank?).map(&:to_i) }) if day_of_week_ids.reject(&:blank?).present?
  }
end
