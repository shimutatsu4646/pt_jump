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
require 'rails_helper'

RSpec.describe City, type: :model do
  it "市区町村データの総数が1747であること" do
    expect(City.all.count).to eq 1747
  end
end
