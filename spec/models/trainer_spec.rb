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
#  instruction_period     :integer          default("unspecified"), not null
#  introduction           :text(65535)
#  max_fee                :integer
#  min_fee                :integer
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
#  index_trainers_on_email                 (email) UNIQUE
#  index_trainers_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe "Trainer Model", type: :model do
  it "名前・年齢・性別・Eメール・パスワードが問題なく入力されている場合、有効になること" do
    trainer = build(:trainer)
    expect(trainer).to be_valid
  end

  describe "nameカラム" do
    it "名前がnilである場合、無効になること" do
      trainer = build(:trainer, name: nil)
      expect(trainer).to be_invalid
    end

    it "名前が空白である場合、無効になること" do
      trainer = build(:trainer, name: "")
      expect(trainer).to be_invalid
    end
  end

  describe "ageカラム" do
    it "年齢がnilである場合、無効になること" do
      trainer = build(:trainer, age: nil)
      expect(trainer).to be_invalid
    end

    it "年齢が全角文字列の数字である場合、無効になること" do
      trainer = build(:trainer, age: "２０")
      expect(trainer).to be_invalid
    end

    it "年齢が半角文字列の数字である場合、有効になること" do
      # バリデーションのnumericality: { only_integer: true }オプションによって、半角数字なら文字列でも数値に変換されるため有効になる
      trainer = build(:trainer, age: "20")
      expect(trainer).to be_valid
    end

    it "年齢に浮動小数点がある場合、無効になること" do
      trainer = build(:trainer, age: 21.5)
      expect(trainer).to be_invalid
    end
  end

  describe "genderカラム" do
    it "性別がnilである場合、無効になること" do
      trainer = build(:trainer, gender: nil)
      expect(trainer).to be_invalid
    end
  end

  describe "timeframeカラム" do
    it "時間帯がnilであっても、有効になること" do
      trainer = build(:trainer, timeframe: nil)
      expect(trainer).to be_valid
    end
  end

  describe "introductionカラム" do
    it "自己紹介がnilであっても、有効になること" do
      trainer = build(:trainer, introduction: nil)
      expect(trainer).to be_valid
    end
  end

  describe "categoryカラム" do
    it "カテゴリーがnilであっても、有効になること" do
      trainer = build(:trainer, category: nil)
      expect(trainer).to be_valid
    end
  end

  describe "instruction_methodカラム" do
    it "指導方法がnilであっても、有効になること" do
      trainer = build(:trainer, instruction_method: nil)
      expect(trainer).to be_valid
    end
  end

  describe "min_feeカラム" do
    it "最低指導料金がnilであっても、有効になること" do
      trainer = build(:trainer, min_fee: nil)
      expect(trainer).to be_valid
    end
  end

  describe "max_feeカラム" do
    it "最高指導料金がnilであっても、有効になること" do
      trainer = build(:trainer, max_fee: nil)
      expect(trainer).to be_valid
    end
  end

  describe "instruction_periodカラム" do
    it "指導期間がnilの場合、無効になること" do
      trainer = build(:trainer, instruction_period: nil)
      expect(trainer).to be_invalid
    end
  end

  describe "emailカラム" do
    it "Eメールがnilである場合、無効になること" do
      trainer = build(:trainer, email: nil)
      expect(trainer).to be_invalid
    end

    it "Eメールが重複している場合、無効になること" do
      create(:trainer, email: "test@example.com")
      trainer = build(:trainer, email: "test@example.com")
      expect(trainer).to be_invalid
    end

    it "Eメールが不適切である場合、無効になること" do
      trainer = build(:trainer, email: "test.com")
      expect(trainer).to be_invalid
    end
  end

  describe "passwordカラム" do
    it "パスワードがnilである場合、無効になること" do
      trainer = build(:trainer, password: nil)
      expect(trainer).to be_invalid
    end

    it "パスワードが７文字である場合、無効になること" do
      trainer = build(:trainer, password: "passwor", password_confirmation: "passwor")
      expect(trainer).to be_invalid
    end

    it "パスワードが８文字である場合、有効になること" do
      trainer = build(:trainer, password: "password", password_confirmation: "password")
      expect(trainer).to be_valid
    end

    it "パスワードが128文字である場合、有効になること" do
      trainer = build(:trainer, password: "#{"a" * 128}", password_confirmation: "#{"a" * 128}")
      expect(trainer).to be_valid
    end

    it "パスワードが129文字である場合、無効になること" do
      trainer = build(:trainer, password: "#{"a" * 129}", password_confirmation: "#{"a" * 129}")
      expect(trainer).to be_invalid
    end

    it "パスワードと確認用パスワードが一致しない場合、無効になること" do
      trainer = build(:trainer, password: "test_pass", password_confirmation: "test_not_pass")
      expect(trainer).to be_invalid
    end
  end
end
