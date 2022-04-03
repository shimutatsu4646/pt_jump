# == Schema Information
#
# Table name: trainees
#
#  id                     :bigint           not null, primary key
#  age                    :integer          not null
#  category               :integer
#  chat_acceptance        :boolean          default(FALSE), not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  gender                 :integer          not null
#  instruction_method     :integer
#  introduction           :text(65535)
#  name                   :string(255)      not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
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

RSpec.describe Trainee, type: :model do
  describe "バリデーション" do
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

    describe "chat_acceptanceカラム" do
      it "チャットの受け入れ可否がnilの場合、無効になること" do
        trainee = build(:trainee, chat_acceptance: nil)
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

  describe "クラスメソッド" do
    describe "Scope" do
      describe "age_fromスコープ" do
        subject { Trainee.age_from(25) }

        let!(:trainee1) { create(:trainee, age: 20) }
        let!(:trainee2) { create(:trainee, age: 25) }

        it "age_fromスコープが条件に当てはまるトレーナーのみを取得すること" do
          is_expected.not_to include trainee1
          is_expected.to include trainee2
        end
      end

      describe "age_toスコープ" do
        subject { Trainee.age_to(20) }

        let!(:trainee1) { create(:trainee, age: 20) }
        let!(:trainee2) { create(:trainee, age: 25) }

        it "age_toスコープが条件に当てはまるトレーナーのみを取得すること" do
          is_expected.to include trainee1
          is_expected.not_to include trainee2
        end
      end

      describe "which_genderスコープ" do
        subject { Trainee.which_gender("male") }

        let!(:trainee1) { create(:trainee, gender: "male") }
        let!(:trainee2) { create(:trainee, gender: "female") }

        it "which_genderスコープが条件に当てはまるトレーナーのみを取得すること" do
          is_expected.to include trainee1
          is_expected.not_to include trainee2
        end
      end

      describe "which_categoryスコープ" do
        subject { Trainee.which_category("losing_weight") }

        let!(:trainee1) { create(:trainee, category: "losing_weight") }
        let!(:trainee2) { create(:trainee, category: "building_muscle") }

        it "which_categoryスコープが条件に当てはまるトレーナーのみを取得すること" do
          is_expected.to include trainee1
          is_expected.not_to include trainee2
        end
      end

      describe "which_instruction_methodスコープ" do
        subject { Trainee.which_instruction_method("offline") }

        let!(:trainee1) { create(:trainee, instruction_method: "offline") }
        let!(:trainee2) { create(:trainee, instruction_method: "online") }

        it "which_instruction_methodスコープが条件に当てはまるトレーナーのみを取得すること" do
          is_expected.to include trainee1
          is_expected.not_to include trainee2
        end
      end

      describe "whether_accept_chatsスコープ" do
        # trueで検索する場合は"1"。条件なしになるのは"0"
        subject { Trainee.whether_accept_chats("1") }

        let!(:trainee1) { create(:trainee, chat_acceptance: true) }
        let!(:trainee2) { create(:trainee, chat_acceptance: false) }

        it "whether_accept_chatsスコープが条件に当てはまるトレーナーのみを取得すること" do
          is_expected.to include trainee1
          is_expected.not_to include trainee2
        end
      end

      describe "what_citiesスコープ" do
        # 事前にcitiesテーブルを結合する必要がある
        subject { Trainee.includes(:cities).what_cities(["1", "3"]) }

        let!(:trainee1) { create(:trainee) }
        let!(:trainee2) { create(:trainee) }

        before do
          trainee1.cities << City.where(id: 1)
          trainee2.cities << City.where(id: 2)
        end

        it "what_citiesスコープが条件に当てはまるトレーナーのみを取得すること" do
          is_expected.to include trainee1
          is_expected.not_to include trainee2
        end
      end

      describe "what_days_of_weekスコープ" do
        # 事前にday_of_weeksテーブルを結合する必要がある
        subject { Trainee.includes(:day_of_weeks).what_days_of_week(["1", "3"]) }

        let!(:trainee1) { create(:trainee) }
        let!(:trainee2) { create(:trainee) }

        before do
          trainee1.day_of_weeks << DayOfWeek.where(id: 1)
          trainee2.day_of_weeks << DayOfWeek.where(id: 2)
        end

        it "what_days_of_weekスコープが条件に当てはまるトレーナーのみを取得すること" do
          is_expected.to include trainee1
          is_expected.not_to include trainee2
        end
      end
    end
  end
end
