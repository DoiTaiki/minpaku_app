# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# メインのサンプルユーザーを1人作成する
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true)

# 追加のユーザーをまとめて生成する
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end

user = User.first
50.times do
  address = Faker::Lorem.unique.sentence(word_count: 1) + "city"
  name = "#{address}'s seaside"
  room_introduction = Faker::Lorem.sentence(word_count: 1)
  price = 2000
  user.rooms.create!( name: name, 
                      room_introduction: room_introduction,
                      price: price,
                      address: address,
                      image: {io: File.open('./test/fixtures/files/images/lake-192990_640.jpg'), filename: 'lake-192990_640.jpg'}
                      )
end

address = "東京都青梅市"
name = "#{address}の駅近"
room_introduction = "駅近です。新築です。"
price = 2000
user.rooms.create!( name: name, 
                    room_introduction: room_introduction,
                    price: price,
                    address: address,
                    image: {io: File.open('./test/fixtures/files/images/japan-1730668_640.jpg'), filename: 'japan-1730668_640.jpg'}
                    )

address = "東京都新宿区"
name = "#{address}の駅近"
room_introduction = "駅近です。都会です。"
price = 2000
user.rooms.create!( name: name, 
                    room_introduction: room_introduction,
                    price: price,
                    address: address,
                    image: {io: File.open('./test/fixtures/files/images/tokyo-4548550_640.jpg'), filename: 'tokyo-4548550_640.jpg'}
                    )

address = "大阪府大阪市"
name = "#{address}の駅近"
room_introduction = "駅近です。都会です。"
price = 2000
user.rooms.create!( name: name, 
                    room_introduction: room_introduction,
                    price: price,
                    address: address,
                    image: {io: File.open('./test/fixtures/files/images/houston-3302007_640.jpg'), filename: 'houston-3302007_640.jpg'}
                    )

address = "大阪府堺市"
name = "#{address}の市街地"
room_introduction = "市街地です。駅近です。観光地です。"
price = 2000
user.rooms.create!( name: name, 
                    room_introduction: room_introduction,
                    price: price,
                    address: address,
                    image: {io: File.open('./test/fixtures/files/images/houston-3302007_640.jpg'), filename: 'houston-3302007_640.jpg'}
                    )

address = "京都府宇治市"
name = "#{address}の市街地"
room_introduction = "市街地です。観光地です。"
price = 2000
user.rooms.create!( name: name, 
                    room_introduction: room_introduction,
                    price: price,
                    address: address,
                    image: {io: File.open('./test/fixtures/files/images/house-5632318_640.jpg'), filename: 'house-5632318_640.jpg'}
                    )

address = "北海道札幌市"
name = "#{address}の市街地"
room_introduction = "市街地です。観光地です。雪降ります。"
price = 2000
user.rooms.create!( name: name, 
                    room_introduction: room_introduction,
                    price: price,
                    address: address,
                    image: {io: File.open('./test/fixtures/files/images/japan-3971122_640.jpg'), filename: 'japan-3971122_640.jpg'}
                    )
