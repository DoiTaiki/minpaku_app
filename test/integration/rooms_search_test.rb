require 'test_helper'

class RoomsSearchTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)

    address = "東京都青梅市"
    name = "#{address}の駅近"
    room_introduction = "駅近です。新築です。"
    price = 2000
    @user.rooms.create!(name: name,
                        room_introduction: room_introduction,
                        price: price,
                        address: address,
                        image: { io: File.open('./test/fixtures/files/images/japan-1730668_640.jpg'), filename: 'japan-1730668_640.jpg' })

    address = "東京都新宿区"
    name = "#{address}の駅近"
    room_introduction = "駅近です。都会です。"
    price = 2000
    @user.rooms.create!(name: name,
                        room_introduction: room_introduction,
                        price: price,
                        address: address,
                        image: { io: File.open('./test/fixtures/files/images/tokyo-4548550_640.jpg'), filename: 'tokyo-4548550_640.jpg' })

    address = "大阪府堺市"
    name = "#{address}の市街地"
    room_introduction = "市街地です。駅近です。観光地です。"
    price = 2000
    @user.rooms.create!(name: name,
                        room_introduction: room_introduction,
                        price: price,
                        address: address,
                        image: { io: File.open('./test/fixtures/files/images/houston-3302007_640.jpg'), filename: 'houston-3302007_640.jpg' })

    address = "北海道札幌市"
    name = "#{address}の市街地"
    room_introduction = "市街地です。観光地です。雪降ります。"
    price = 2000
    @user.rooms.create!(name: name,
                        room_introduction: room_introduction,
                        price: price,
                        address: address,
                        image: { io: File.open('./test/fixtures/files/images/japan-3971122_640.jpg'), filename: 'japan-3971122_640.jpg' })
  end

  test "should get search with some keywords or minus keywords results" do
    get search_rooms_path, params: {
      keyword: "東京都　大阪府",
      column: "address",
    }
    assert_template 'rooms/search'
    assert_equal 0, assigns(:strict_searched_rooms).to_a.count
    assert_equal 3, assigns(:searched_rooms).to_a.count

    get search_rooms_path, params: {
      keyword: "東京都　青梅市",
      column: "address",
    }
    assert_template 'rooms/search'
    assert_equal 1, assigns(:strict_searched_rooms).to_a.count
    assert_equal 1, assigns(:searched_rooms).to_a.count

    get search_rooms_path, params: {
      keyword: "東京都　-青梅市",
      column: "address",
    }
    assert_template 'rooms/search'
    assert_equal 1, assigns(:strict_searched_rooms).to_a.count
    assert_equal 0, assigns(:searched_rooms).to_a.count

    get search_rooms_path, params: {
      keyword: "雪",
      column: "room_introduction",
    }
    assert_template 'rooms/search'
    assert_equal 1, assigns(:strict_searched_rooms).to_a.count
    assert_equal 0, assigns(:searched_rooms).to_a.count

    get search_rooms_path, params: {
      keyword: "市街地　雪",
      column: "room_introduction",
    }
    assert_template 'rooms/search'
    assert_equal 1, assigns(:strict_searched_rooms).to_a.count
    assert_equal 1, assigns(:searched_rooms).to_a.count

    get search_rooms_path, params: {
      keyword: "市街地　-雪",
      column: "room_introduction",
    }
    assert_template 'rooms/search'
    assert_equal 1, assigns(:strict_searched_rooms).to_a.count
    assert_equal 0, assigns(:searched_rooms).to_a.count
  end
end
