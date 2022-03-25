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
require 'rails_helper'

# 有効な属性で初期化された場合は、モデルの状態が有効(valid)になっていること
# バリデーションを失敗させるデータであれば、モデルの状態が有効になっていないこと
# クラスメソッドとインスタンスメソッドが期待通りに動作すること

RSpec.describe "Trainee Model", type: :model do
  it "名前・年齢・性別・Eメール・パスワードが問題なく入力されている場合、有効になること" do
    trainee = build(:trainee)
    expect(trainee).to be_valid
  end

  describe "nameカラム" do
    it "名前がnilである場合、無効になること" do
      trainee = build(:trainee, name: nil)
      expect(trainee).to be_invalid
    end

    it "名前が空白である場合、無効になること" do
      trainee = build(:trainee, name: "")
      expect(trainee).to be_invalid
    end
  end

  describe "ageカラム" do
    it "年齢がnilである場合、無効になること" do
      trainee = build(:trainee, age: nil)
      expect(trainee).to be_invalid
    end

    it "年齢が全角文字列の数字である場合、無効になること" do
      trainee = build(:trainee, age: "２０")
      expect(trainee).to be_invalid
    end

    it "年齢が半角文字列の数字である場合、有効になること" do
      # バリデーションのnumericality: { only_integer: true }オプションによって、半角数字なら文字列でも数値に変換されるため有効になる
      trainee = build(:trainee, age: "20")
      expect(trainee).to be_valid
    end

    it "年齢に浮動小数点がある場合、無効になること" do
      trainee = build(:trainee, age: 21.5)
      expect(trainee).to be_invalid
    end
  end

  describe "genderカラム" do
    it "性別がnilである場合、無効になること" do
      trainee = build(:trainee, gender: nil)
      expect(trainee).to be_invalid
    end
  end

  describe "timeframeカラム" do
    it "時間帯がnilであっても、有効になること" do
      trainee = build(:trainee, timeframe: nil)
      expect(trainee).to be_valid
    end
  end

  describe "introductionカラム" do
    it "自己紹介がnilであっても、有効になること" do
      trainee = build(:trainee, introduction: nil)
      expect(trainee).to be_valid
    end
  end

  describe "categoryカラム" do
    it "カテゴリーがnilであっても、有効になること" do
      trainee = build(:trainee, category: nil)
      expect(trainee).to be_valid
    end
  end

  describe "instruction_methodカラム" do
    it "指導方法がnilであっても、有効になること" do
      trainee = build(:trainee, instruction_method: nil)
      expect(trainee).to be_valid
    end
  end

  describe "dm_allowedカラム" do
    it "DM許可がnilの場合、無効になること" do
      trainee = build(:trainee, dm_allowed: nil)
      expect(trainee).to be_invalid
    end
  end

  describe "emailカラム" do
    it "Eメールがnilである場合、無効になること" do
      trainee = build(:trainee, email: nil)
      expect(trainee).to be_invalid
    end

    it "Eメールが重複している場合、無効になること" do
      create(:trainee, email: "test@example.com")
      trainee = build(:trainee, email: "test@example.com")
      expect(trainee).to be_invalid
    end

    it "Eメールが不適切である場合、無効になること" do
      trainee = build(:trainee, email: "test.com")
      expect(trainee).to be_invalid
    end
  end

  describe "passwordカラム" do
    it "パスワードがnilである場合、無効になること" do
      trainee = build(:trainee, password: nil)
      expect(trainee).to be_invalid
    end

    it "パスワードが７文字である場合、無効になること" do
      trainee = build(:trainee, password: "passwor", password_confirmation: "passwor")
      expect(trainee).to be_invalid
    end

    it "パスワードが８文字である場合、有効になること" do
      trainee = build(:trainee, password: "password", password_confirmation: "password")
      expect(trainee).to be_valid
    end

    it "パスワードが128文字である場合、有効になること" do
      trainee = build(:trainee, password: "#{"a" * 128}", password_confirmation: "#{"a" * 128}")
      expect(trainee).to be_valid
    end

    it "パスワードが129文字である場合、無効になること" do
      trainee = build(:trainee, password: "#{"a" * 129}", password_confirmation: "#{"a" * 129}")
      expect(trainee).to be_invalid
    end

    it "パスワードと確認用パスワードが一致しない場合、無効になること" do
      trainee = build(:trainee, password: "test_pass", password_confirmation: "test_not_pass")
      expect(trainee).to be_invalid
    end
  end
end
