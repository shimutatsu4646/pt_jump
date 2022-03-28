# == Schema Information
#
# Table name: prefectures
#
#  id        :bigint           not null, primary key
#  name      :string(255)      not null
#  region_id :bigint           not null
#
# Indexes
#
#  index_prefectures_on_region_id  (region_id)
#
# Foreign Keys
#
#  fk_rails_...  (region_id => regions.id)
#
class Prefecture < ApplicationRecord
  belongs_to :region
  has_many :cities
  has_many :trainees, through: :cities
  has_many :trainers, through: :cities

  validates :name, presence: true
end
