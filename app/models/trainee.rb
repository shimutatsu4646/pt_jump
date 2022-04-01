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
  has_and_belongs_to_many :cities
  has_many :prefectures, through: :cities

  scope :search_trainee, -> (trainee_search_params) do
    return if trainee_search_params.blank?

    whether_allow_dm(trainee_search_params[:dm_allowed]).
      age_from(trainee_search_params[:age_from]).
      age_to(trainee_search_params[:age_to]).
      which_gender(trainee_search_params[:gender]).
      which_category(trainee_search_params[:category]).
      which_instruction_method(trainee_search_params[:instruction_method]).
      what_cities(trainee_search_params[:city_ids])
  end

  # ↓検索ページにて、チェックボックスにチェックがない場合適応しない。
  scope :whether_allow_dm, -> (dm_allowed) {
    where(dm_allowed: dm_allowed) if dm_allowed == "1"
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
end
