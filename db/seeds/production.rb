require "csv"
# 都道府県・市区町村データの作成
file_path = "lib/japan_area_data.csv"
# CSVを1行毎の配列へ変換
area_data = CSV.read(file_path)
# 地方区分データ抽出
regions_list = area_data.map { |row| row[1] }.uniq
# 都道府県データ抽出
prefectures_list = area_data.map { |row| row[1,2] }.uniq
# 市区町村データ抽出
cities_list = area_data.map do |row|
  next if row[3] == nil
  row[2, 3]
end.compact

# 地方区分データ作成
regions_list.each do |region|
  Region.create!(name: region)
end
# 都道府県データ作成
prefectures_list.each do |region, prefecture|
  region = Region.find_by(name: region)
  region.prefectures.create(name: prefecture)
end
# 市区町村データ作成
cities_list.each do |prefecture, city|
  prefecture = Prefecture.find_by(name: prefecture)
  prefecture.cities.create(name: city)
end

# 曜日データ作成
DayOfWeek.create!(name: "月曜日")
DayOfWeek.create!(name: "火曜日")
DayOfWeek.create!(name: "水曜日")
DayOfWeek.create!(name: "木曜日")
DayOfWeek.create!(name: "金曜日")
DayOfWeek.create!(name: "土曜日")
DayOfWeek.create!(name: "日曜日")


# トレーニーデータの作成

# trainee1はnilにできるカラムは全てnilにする。
# trainee2~trainee10
# ２つの都道府県を関連付けする。（東京、大阪）
# １つの都道府県につき、5~8件の市区町村を活動地域とする。
# ２種類の性別、２種類の指導方法、2種類のdm許可、4種類のカテゴリーを全て網羅する。
# 一人のトレーニーが複数の都道府県を活動地域とする。
# 一人のトレーニーが複数の都道府県を活動地域とする。
Trainee.create!(
  name: "trainee1",
  age: 21,
  gender: "male",
  introduction: nil,
  category: nil,
  instruction_method: nil,
  dm_allowed: false,
  email: "trainee1@example.com",
  password: "password1"
)

trainee2 = Trainee.create!(
  name: "trainee2",
  age: 22,
  gender: "male",
  introduction: "よろしくお願いします。" * 10,
  category: "building_muscle",
  instruction_method: "online",
  dm_allowed: false,
  email: "trainee2@example.com",
  password: "password2"
)
trainee2.cities << City.where(prefecture_id: [13]).limit(5)
trainee2.day_of_weeks << DayOfWeek.where(name: "月曜日")

trainee3 = Trainee.create!(
  name: "trainee3",
  age: 23,
  gender: "male",
  introduction: "よろしくお願いします。" * 10,
  category: "losing_weight",
  instruction_method: "offline",
  dm_allowed: true,
  email: "trainee3@example.com",
  password: "password3"
)
trainee3.cities << City.where(prefecture_id: [13]).limit(6)
trainee3.day_of_weeks << DayOfWeek.where(name: "火曜日")

trainee4 = Trainee.create!(
  name: "trainee4",
  age: 24,
  gender: "female",
  introduction: "よろしくお願いします。" * 10,
  category: "physical_function",
  instruction_method: "online",
  dm_allowed: true,
  email: "trainee4@example.com",
  password: "password4"
)
trainee4.cities << City.where(prefecture_id: [13]).limit(7)
trainee4.day_of_weeks << DayOfWeek.where(name: "水曜日")

trainee5 = Trainee.create!(
  name: "trainee5",
  age: 25,
  gender: "female",
  introduction: "よろしくお願いします。" * 10,
  category: "physical_therapy",
  instruction_method: "offline",
  dm_allowed: false,
  email: "trainee5@example.com",
  password: "password5"
)
trainee5.cities << City.where(prefecture_id: [13]).limit(8)
trainee5.day_of_weeks << DayOfWeek.where(name: "木曜日")

trainee6 = Trainee.create!(
  name: "trainee6",
  age: 26,
  gender: "female",
  introduction: "よろしくお願いします。" * 10,
  category: "losing_weight",
  instruction_method: "offline",
  dm_allowed: false,
  email: "trainee6@example.com",
  password: "password6"
)
trainee6.cities << City.where(prefecture_id: [27]).limit(5)
trainee6.day_of_weeks << DayOfWeek.where(name: "金曜日")

trainee7 = Trainee.create!(
  name: "trainee7",
  age: 27,
  gender: "female",
  introduction: "よろしくお願いします。" * 10,
  category: "building_muscle",
  instruction_method: "online",
  dm_allowed: false,
  email: "trainee7@example.com",
  password: "password7"
)
trainee7.cities << City.where(prefecture_id: [27]).limit(6)
trainee7.day_of_weeks << DayOfWeek.where(name: "土曜日")

trainee8 = Trainee.create!(
  name: "trainee8",
  age: 28,
  gender: "male",
  introduction: "よろしくお願いします。" * 10,
  category: "physical_function",
  instruction_method: "offline",
  dm_allowed: true,
  email: "trainee8@example.com",
  password: "password8"
)
trainee8.cities << City.where(prefecture_id: [27]).limit(7)
trainee8.day_of_weeks << DayOfWeek.where(name: "日曜日")

trainee9 = Trainee.create!(
  name: "trainee9",
  age: 29,
  gender: "male",
  introduction: "よろしくお願いします。" * 10,
  category: "physical_therapy",
  instruction_method: "offline",
  dm_allowed: true,
  email: "trainee9@example.com",
  password: "password9"
)
trainee9.cities << City.where(prefecture_id: [27]).limit(8)
trainee9.day_of_weeks << DayOfWeek.where(name: "月曜日")
trainee9.day_of_weeks << DayOfWeek.where(name: "火曜日")
trainee9.day_of_weeks << DayOfWeek.where(name: "水曜日")
trainee9.day_of_weeks << DayOfWeek.where(name: "木曜日")
trainee9.day_of_weeks << DayOfWeek.where(name: "金曜日")

trainee10 = Trainee.create!(
  name: "trainee10",
  age: 30,
  gender: "male",
  introduction: "よろしくお願いします。" * 10,
  category: "physical_therapy",
  instruction_method: "offline",
  dm_allowed: true,
  email: "trainee10@example.com",
  password: "password10"
)
# 複数の都道府県を活動地域としたトレーニーデータ
trainee10.cities << City.where(prefecture_id: [13]).limit(8)
trainee10.cities << City.where(prefecture_id: [27]).limit(8)
trainee10.day_of_weeks << DayOfWeek.where(name: "土曜日")
trainee10.day_of_weeks << DayOfWeek.where(name: "日曜日")


# トレーナーデータの作成

# trainer1はnilにできるカラムは全てnilにする。
# trainee2~trainee10
# ２つの都道府県を関連付けする。（東京、大阪）
# １つの都道府県につき、5~8件の市区町村を活動地域とする。
# ２種類の性別、２種類の指導方法、2種類の指導期間、4種類のカテゴリーを全て網羅する。
# min_feeは1000円ずつ増やす。
# 一人のトレーナーが複数の都道府県を活動地域とする。
# 一人のトレーナーが複数の都道府県を活動地域とする。
Trainer.create!(
  name: "trainer1",
  age: 21,
  gender: "male",
  introduction: nil,
  category: nil,
  instruction_method: nil,
  min_fee: nil,
  instruction_period: nil,
  email: "trainer1@example.com",
  password: "password1"
)

trainer2 = Trainer.create!(
  name: "trainer2",
  age: 22,
  gender: "male",
  introduction: "よろしくお願いします。" * 10,
  category: "building_muscle",
  instruction_method: "online",
  min_fee: 1000,
  instruction_period: "below_one_month",
  email: "trainer2@example.com",
  password: "password2"
)
trainer2.cities << City.where(prefecture_id: [13]).limit(5)
trainer2.day_of_weeks << DayOfWeek.where(name: "月曜日")

trainer3 = Trainer.create!(
  name: "trainer3",
  age: 23,
  gender: "male",
  introduction: "よろしくお願いします。" * 10,
  category: "losing_weight",
  instruction_method: "offline",
  min_fee: 2000,
  instruction_period: "above_one_month",
  email: "trainer3@example.com",
  password: "password3"
)
trainer3.cities << City.where(prefecture_id: [13]).limit(6)
trainer3.day_of_weeks << DayOfWeek.where(name: "火曜日")

trainer4 = Trainer.create!(
  name: "trainer4",
  age: 24,
  gender: "female",
  introduction: "よろしくお願いします。" * 10,
  category: "physical_function",
  instruction_method: "online",
  min_fee: 2000,
  instruction_period: "below_one_month",
  email: "trainer4@example.com",
  password: "password4"
)
trainer4.cities << City.where(prefecture_id: [13]).limit(7)
trainer4.day_of_weeks << DayOfWeek.where(name: "水曜日")

trainer5 = Trainer.create!(
  name: "trainer5",
  age: 25,
  gender: "female",
  introduction: "よろしくお願いします。" * 10,
  category: "physical_therapy",
  instruction_method: "offline",
  min_fee: 3000,
  instruction_period: "above_one_month",
  email: "trainer5@example.com",
  password: "password5"
)
trainer5.cities << City.where(prefecture_id: [13]).limit(8)
trainer5.day_of_weeks << DayOfWeek.where(name: "木曜日")

trainer6 = Trainer.create!(
  name: "trainer6",
  age: 26,
  gender: "female",
  introduction: "よろしくお願いします。" * 10,
  category: "losing_weight",
  instruction_method: "offline",
  min_fee: 4000,
  instruction_period: "below_one_month",
  email: "trainer6@example.com",
  password: "password6"
)
trainer6.cities << City.where(prefecture_id: [27]).limit(5)
trainer6.day_of_weeks << DayOfWeek.where(name: "金曜日")

trainer7 = Trainer.create!(
  name: "trainer7",
  age: 27,
  gender: "female",
  introduction: "よろしくお願いします。" * 10,
  category: "building_muscle",
  instruction_method: "online",
  min_fee: 5000,
  instruction_period: "above_one_month",
  email: "trainer7@example.com",
  password: "password7"
)
trainer7.cities << City.where(prefecture_id: [27]).limit(6)
trainer7.day_of_weeks << DayOfWeek.where(name: "土曜日")

trainer8 = Trainer.create!(
  name: "trainer8",
  age: 28,
  gender: "male",
  introduction: "よろしくお願いします。" * 10,
  category: "physical_function",
  instruction_method: "offline",
  min_fee: 6000,
  instruction_period: "below_one_month",
  email: "trainer8@example.com",
  password: "password8"
)
trainer8.cities << City.where(prefecture_id: [27]).limit(7)
trainer8.day_of_weeks << DayOfWeek.where(name: "日曜日")

trainer9 = Trainer.create!(
  name: "trainer9",
  age: 29,
  gender: "male",
  introduction: "よろしくお願いします。" * 10,
  category: "physical_therapy",
  instruction_method: "offline",
  min_fee: 7000,
  instruction_period: "above_one_month",
  email: "trainer9@example.com",
  password: "password9"
)
trainer9.cities << City.where(prefecture_id: [27]).limit(8)
trainer9.day_of_weeks << DayOfWeek.where(name: "月曜日")
trainer9.day_of_weeks << DayOfWeek.where(name: "火曜日")
trainer9.day_of_weeks << DayOfWeek.where(name: "水曜日")
trainer9.day_of_weeks << DayOfWeek.where(name: "木曜日")
trainer9.day_of_weeks << DayOfWeek.where(name: "金曜日")

trainer10 = Trainer.create!(
  name: "trainer10",
  age: 30,
  gender: "male",
  introduction: "よろしくお願いします。" * 10,
  category: "physical_therapy",
  instruction_method: "offline",
  min_fee: 8000,
  instruction_period: "below_one_month",
  email: "trainer10@example.com",
  password: "password10"
)
# 複数の都道府県を活動地域としたトレーナーデータ
trainer10.cities << City.where(prefecture_id: [13]).limit(8)
trainer10.cities << City.where(prefecture_id: [27]).limit(8)
trainer10.day_of_weeks << DayOfWeek.where(name: "土曜日")
trainer10.day_of_weeks << DayOfWeek.where(name: "日曜日")

# トレーニーのデフォルトのプロフィール画像のパス
trainee_image_file = "default_trainee_avatar.png"
trainee_image_path = Rails.root.join('app', 'assets', 'images', trainee_image_file)
# ActiveStorageのavatarにデフォルトのプロフィール画像を添付
Trainee.all.each do |trainee|
  trainee.avatar.attach(io: File.open(trainee_image_path), filename: trainee_image_file)
end

# トレーナーのデフォルトのプロフィール画像のパス
trainer_image_file = "default_trainer_avatar.png"
trainer_image_path = Rails.root.join('app', 'assets', 'images', trainer_image_file)
Trainer.all.each do |trainer|
  trainer.avatar.attach(io: File.open(trainer_image_path), filename: trainer_image_file)
end
