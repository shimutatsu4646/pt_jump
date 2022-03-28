# == Schema Information
#
# Table name: regions
#
#  id   :bigint           not null, primary key
#  name :string(255)      not null
#
class Region < ApplicationRecord
  has_many :prefectures

  validates :name, presence: true
end
