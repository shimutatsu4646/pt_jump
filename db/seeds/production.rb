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
# ２種類の性別、２種類の指導方法、チャット受け入れの可否、4種類のカテゴリーを全て網羅する。
# 一人のトレーニーが複数の都道府県を活動地域とする。
# 一人のトレーニーが複数の都道府県を活動地域とする。
Trainee.create!(
  name: "trainee1",
  age: 21,
  gender: "male",
  introduction: nil,
  category: nil,
  instruction_method: nil,
  chat_acceptance: false,
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
  chat_acceptance: false,
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
  chat_acceptance: true,
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
  chat_acceptance: true,
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
  chat_acceptance: false,
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
  chat_acceptance: false,
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
  chat_acceptance: false,
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
  chat_acceptance: true,
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
  chat_acceptance: true,
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
  chat_acceptance: true,
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


# チャットデータ
# トレーナー・トレーニー共にチャットデータはidが2と3のユーザーに絞り作成する。
# 全てのユーザーにチャットデータがある状態にするのは困難であるため。
# idが1のユーザーは、

# idが2のトレーナー・トレーニー同士のチャット
Chat.create!(
  content: "こんにちは。筋肉を付けたいです。指導していただけませんか？",
  trainee_id: 2,
  trainer_id: 2,
  from_trainee: true
)
Chat.create!(
  content: "いいですよ！運動経験はありますか？",
  trainee_id: 2,
  trainer_id: 2,
  from_trainee: false
)
Chat.create!(
  content: "サッカーをやっていました。",
  trainee_id: 2,
  trainer_id: 2,
  from_trainee: true
)
Chat.create!(
  content: "運動経験があるのでしたら、ジムのマシンを使ってトレーニングするのが一番効果が出やすいですよ。
  ジムに通ってますか？",
  trainee_id: 2,
  trainer_id: 2,
  from_trainee: false
)
Chat.create!(
  content: "通っていません。どこかのジムに入会しないといけないですか？",
  trainee_id: 2,
  trainer_id: 2,
  from_trainee: true
)
Chat.create!(
  content: "入会しなくて大丈夫です！
  小さいスペースですが、私がトレーニングスペースを確保しているので、そこでできます。料金は指導料だけです。",
  trainee_id: 2,
  trainer_id: 2,
  from_trainee: false
)
Chat.create!(
  content: "わかりました。よろしくおねがいします。",
  trainee_id: 2,
  trainer_id: 2,
  from_trainee: true
)
Chat.create!(
  content: "よろしくおねがいします！
  あとは、食事の見直しが必要かもしれないので、普段の食事を教えていただいてもいいですか？",
  trainee_id: 2,
  trainer_id: 2,
  from_trainee: false
)

# idが2のトレーニーとidが3のトレーナー
Chat.create!(
  content: "こんにちは。再来月までに体重を減らしたいのですが、指導いただけませんか？",
  trainee_id: 2,
  trainer_id: 3,
  from_trainee: true
)
Chat.create!(
  content: "もちろんいいですよ！なぜ体重を減らしたいのですか？",
  trainee_id: 2,
  trainer_id: 3,
  from_trainee: false
)
Chat.create!(
  content: "友達の結婚式がありまして、ドレスを綺麗に着こなしたいんです。",
  trainee_id: 2,
  trainer_id: 3,
  from_trainee: true
)
Chat.create!(
  content: "わかりました。一緒に頑張りましょう！
  来月の月末までの契約でよろしいですか？",
  trainee_id: 2,
  trainer_id: 3,
  from_trainee: false
)

# idが3のトレーニーとidが2のトレーナー
Chat.create!(
  content: "こんにちは！ダイエットがしたいようですね",
  trainer_id: 2,
  trainee_id: 3,
  from_trainee: false
)
Chat.create!(
  content: "私はボディビルの大会に出場したこともあるので、私が指導したらしっかり結果を出しますよ！ダイエットの指導も得意です！",
  trainer_id: 2,
  trainee_id: 3,
  from_trainee: false
)
Chat.create!(
  content: "それはいいですね！",
  trainer_id: 2,
  trainee_id: 3,
  from_trainee: true
)
Chat.create!(
  content: "それでは、いつから指導しましょうか？",
  trainer_id: 2,
  trainee_id: 3,
  from_trainee: false
)
Chat.create!(
  content: "今月は忙しいので、来月ならいいです",
  trainer_id: 2,
  trainee_id: 3,
  from_trainee: true
)


# 契約データ

# ！start_date(指導開始日)とend_date(終了日)のバリデーションに注意！
# 現在の日付よりも過去であると作成できない
# 契約はidが2もしくは3のトレーナーに対するものとする



# 成立済みの契約データ

# 過去に成立した契約データを生成するため、createではなくnew + save(validate:false)を使用。
# 契約リクエストした日時も矛盾がないようにcreated_atを変更。

Contract.new(
  id: 1,
  trainee_id: 2,
  trainer_id: 2,
  start_date: Date.parse("2022/03/01"),
  end_date: Date.parse("2022/04/01"),
  final_decision: true
).save(validate: false)
Contract.find(1).update_attribute(:created_at, Time.parse("2022/02/27") )

Contract.new(
  id: 2,
  trainee_id: 3,
  trainer_id: 2,
  start_date: Date.parse("2022/03/01"),
  end_date: Date.parse("2022/04/14"),
  final_decision: true
).save(validate: false)
Contract.find(2).update_attribute(:created_at, Time.parse("2022/03/01") )

Contract.new(
  id: 3,
  trainee_id: 4,
  trainer_id: 2,
  start_date: Date.parse("2022/02/01"),
  end_date: Date.parse("2022/04/01"),
  final_decision: true
).save(validate: false)
Contract.find(3).update_attribute(:created_at, Time.parse("2022/01/31") )

Contract.new(
  id: 4,
  trainee_id: 5,
  trainer_id: 3,
  start_date: Date.parse("2022/03/01"),
  end_date: Date.parse("2022/04/01"),
  final_decision: true
).save(validate: false)
Contract.find(4).update_attribute(:created_at, Time.parse("2022/02/25") )

Contract.new(
  id: 5,
  trainee_id: 6,
  trainer_id: 3,
  start_date: Date.parse("2022/04/01"),
  end_date: Date.parse("2022/04/21"),
  final_decision: true
).save(validate: false)
Contract.find(5).update_attribute(:created_at, Time.parse("2022/03/30") )

Contract.new(
  id: 6,
  trainee_id: 7,
  trainer_id: 3,
  start_date: Date.parse("2022/03/01"),
  end_date: Date.parse("2022/04/01"),
  final_decision: true
).save(validate: false)
Contract.find(6).update_attribute(:created_at, Time.parse("2022/02/21") )

Contract.new(
  id: 7,
  trainee_id: 2,
  trainer_id: 3,
  start_date: Date.parse("2022/02/01"),
  end_date: Date.parse("2022/03/01"),
  final_decision: true
).save(validate: false)
Contract.find(7).update_attribute(:created_at, Time.parse("2022/01/30") )


# リクエスト中の契約データ

Contract.create!(
  trainee_id: 2,
  trainer_id: 2,
  start_date: Date.current,
  end_date: Date.current + 30,
  final_decision: false
)
Contract.create!(
  trainee_id: 2,
  trainer_id: 2,
  start_date: Date.current + 31,
  end_date: Date.current + 61,
  final_decision: false
)
Contract.create!(
  trainee_id: 2,
  trainer_id: 3,
  start_date: Date.current + 61,
  end_date: Date.current + 121,
  final_decision: false
)

Contract.create!(
  trainee_id: 3,
  trainer_id: 2,
  start_date: Date.current + 3,
  end_date: Date.current + 33,
  final_decision: false
)
Contract.create!(
  trainee_id: 3,
  trainer_id: 3,
  start_date: Date.current + 34,
  end_date: Date.current + 64,
  final_decision: false
)

Contract.create!(
  trainee_id: 4,
  trainer_id: 2,
  start_date: Date.current + 7,
  end_date: Date.current + 67,
  final_decision: false
)

Contract.create!(
  trainee_id: 5,
  trainer_id: 3,
  start_date: Date.current,
  end_date: Date.current + 30,
  final_decision: false
)


# トレーナー候補データ

Contract.create!(
  trainee_id: 6,
  trainer_id: 3,
  start_date: Date.current + 1,
  end_date: Date.current + 31,
  final_decision: false
)

Contract.create!(
  trainee_id: 7,
  trainer_id: 3,
  start_date: Date.current + 5,
  end_date: Date.current + 95,
  final_decision: false
)


Candidate.create!(
  trainee_id: 2,
  trainer_id: 2,
)

Candidate.create!(
  trainee_id: 2,
  trainer_id: 3,
)

Candidate.create!(
  trainee_id: 2,
  trainer_id: 4,
)

Candidate.create!(
  trainee_id: 3,
  trainer_id: 3,
)

Candidate.create!(
  trainee_id: 3,
  trainer_id: 4,
)

Candidate.create!(
  trainee_id: 3,
  trainer_id: 5,
)

# レビューのデータ

Review.create!(
  trainee_id: 2,
  trainer_id: 2,
  title: "非常に丁寧な指導でした。",
  comment: "またお願いしたいと思います。",
  star_rate: 5.0
)

Review.create!(
  trainee_id: 3,
  trainer_id: 2,
  title: "チャットの返信スピード",
  comment: "チャットが帰ってくるのが遅かったです。
  それ以外はとても良かったので星４とします。",
  star_rate: 4.0
)

Review.create!(
  trainee_id: 5,
  trainer_id: 3,
  title: "適当な指導",
  comment: "威圧的な指導で、楽しくありませんでした。
  おすすめしません。",
  star_rate: 2.0
)

Review.create!(
  trainee_id: 6,
  trainer_id: 3,
  title: "微妙",
  comment: "トレーナー自身の体型は非常によいです。ご自身でトレーニングをされているようですが、指導は微妙でした。",
  star_rate: 3.0
)

