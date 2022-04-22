# == Schema Information
#
# Table name: day_of_weeks
#
#  id   :bigint           not null, primary key
#  name :string(255)      not null
#
require 'rails_helper'

RSpec.describe DayOfWeek, type: :model do
  it "曜日データの総数が7であること" do
    expect(DayOfWeek.all.count).to eq 7
  end
end
