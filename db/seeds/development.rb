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

# トレーニーデータの作成
5.times do |i|
  Trainee.create!(
    name: "trainee#{i}",
    age: (20 + i),
    gender: "male",
    timeframe: nil,
    introduction: nil,
    category: nil,
    instruction_method: nil,
    dm_allowed: false,
    email: "trainee#{i}@example.com",
    password: "password#{i}"
  )
end

# トレーナーデータの作成
5.times do |i|
  Trainer.create!(
    name: "trainer#{i}",
    age: (20 + i),
    gender: "female",
    timeframe: nil,
    introduction: nil,
    category: nil,
    instruction_method: nil,
    min_fee: nil,
    max_fee: nil,
    instruction_period: "unspecified",
    email: "trainer#{i}@example.com",
    password: "password#{i}"
  )
end

# トレーニーのデフォルトのプロフィール画像のパス
trainee_image_file = "default_trainee_avatar.png"
trainee_image_path = Rails.root.join('app', 'assets', 'images', trainee_image_file)

# トレーニーの活動地域
trainee_city = City.where(id: [1]) # 札幌市

# ユーザーの活動地域データの作成
# ActiveStorageのavatarにデフォルトのプロフィール画像を添付
Trainee.all.each do |trainee|
  trainee.avatar.attach(io: File.open(trainee_image_path), filename: trainee_image_file)
  trainee.cities << trainee_city
end

# トレーナーの活動地域
trainer_city = City.where(id: [634]) # 千代田区

# トレーナーのデフォルトのプロフィール画像のパス
trainer_image_file = "default_trainer_avatar.png"
trainer_image_path = Rails.root.join('app', 'assets', 'images', trainer_image_file)

Trainer.all.each do |trainer|
  trainer.avatar.attach(io: File.open(trainer_image_path), filename: trainer_image_file)
  trainer.cities << trainer_city
end
