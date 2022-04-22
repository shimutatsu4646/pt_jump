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
