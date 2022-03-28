# == Schema Information
#
# Table name: regions
#
#  id   :bigint           not null, primary key
#  name :string(255)      not null
#
require 'rails_helper'

RSpec.describe Region, type: :model do
  it "地方区分の数が8であること" do
    expect(Region.all.count).to eq 8
  end
end
