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
require 'rails_helper'

RSpec.describe Prefecture, type: :model do
  it "都道府県の数が47であること" do
    expect(Prefecture.all.count).to eq 47
  end
end
