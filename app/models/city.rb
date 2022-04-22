# == Schema Information
#
# Table name: cities
#
#  id            :bigint           not null, primary key
#  name          :string(255)      not null
#  prefecture_id :bigint           not null
#
# Indexes
#
#  index_cities_on_prefecture_id  (prefecture_id)
#
# Foreign Keys
#
#  fk_rails_...  (prefecture_id => prefectures.id)
#
class City < ApplicationRecord
  belongs_to :prefecture
  has_and_belongs_to_many :trainees
  has_and_belongs_to_many :trainers

  validates :name, presence: true
end
