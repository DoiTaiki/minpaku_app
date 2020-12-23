require 'test_helper'

class RoomsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @room = @user.rooms.create!(name: Faker::Lorem.sentence(word_count: 1), 
                                room_introduction: Faker::Lorem.sentence(word_count: 1),
                                price: 1000,
                                address: Faker::Lorem.unique.sentence(word_count: 1) + "city",
                                image: {io: File.open('./test/fixtures/files/images/lake-192990_640.jpg'), filename: 'lake-192990_640.jpg'}
                                )
    
    address = "東京都青梅市"
    name = "#{address}の駅近"
    room_introduction = "駅近です。新築です。"
    price = 2000
    @user.rooms.create!( name: name, 
                        room_introduction: room_introduction,
                        price: price,
                        address: address,
                        image: {io: File.open('./test/fixtures/files/images/japan-1730668_640.jpg'), filename: 'japan-1730668_640.jpg'}
                        )
                        
    address = "東京都新宿区"
    name = "#{address}の駅近"
    room_introduction = "駅近です。都会です。"
    price = 2000
    @user.rooms.create!( name: name, 
                        room_introduction: room_introduction,
                        price: price,
                        address: address,
                        image: {io: File.open('./test/fixtures/files/images/tokyo-4548550_640.jpg'), filename: 'tokyo-4548550_640.jpg'}
                        )
    
    address = "大阪府堺市"
    name = "#{address}の市街地"
    room_introduction = "市街地です。駅近です。観光地です。"
    price = 2000
    @user.rooms.create!( name: name, 
                        room_introduction: room_introduction,
                        price: price,
                        address: address,
                        image: {io: File.open('./test/fixtures/files/images/houston-3302007_640.jpg'), filename: 'houston-3302007_640.jpg'}
                        )

    address = "北海道札幌市"
    name = "#{address}の市街地"
    room_introduction = "市街地です。観光地です。雪降ります。"
    price = 2000
    @user.rooms.create!( name: name, 
                        room_introduction: room_introduction,
                        price: price,
                        address: address,
                        image: {io: File.open('./test/fixtures/files/images/japan-3971122_640.jpg'), filename: 'japan-3971122_640.jpg'}
                        )
  end
  
  test "should get new" do
    log_in_as(@user)
    get new_room_path
    assert_response :success
  end
  
  test "should get show" do
    get room_path(@room)
    assert_response :success
  end
  
  test "should get edit" do
    log_in_as(@user)
    get edit_room_path(@room)
    assert_response :success
  end
  
  test "should get posts" do
    log_in_as(@user)
    get posts_rooms_path
    assert_response :success
  end
  
  test "should redirect new when not logged in" do
    get new_room_path
    assert_redirected_to sign_in_user_path
  end
  
  test "should redirect create when not logged in" do
    assert_no_difference 'Room.count' do
      post rooms_path, params: { room: { name: Faker::Lorem.sentence(word_count: 1), 
                                          room_introduction: Faker::Lorem.sentence(word_count: 1),
                                          price: 1000,
                                          address: Faker::Lorem.unique.sentence(word_count: 1) + "city",
                                          image: {io: File.open('./test/fixtures/files/images/lake-192990_640.jpg'), filename: 'lake-192990_640.jpg'}
                                          } }
    end
    assert_redirected_to sign_in_user_path
  end
  
  test "should redirect edit when not logged in" do
    get edit_room_path(@room)
    assert_redirected_to sign_in_user_path
  end
  
  test "should redirect update when not logged in" do
    assert_no_difference 'Room.count' do
      patch room_path(@room), params: { room: { name: "update", 
                                          room_introduction: "upadate",
                                          price: 2000,
                                          address: Faker::Lorem.unique.sentence(word_count: 1) + "city",
                                          image: {io: File.open('./test/fixtures/files/images/lake-192990_640.jpg'), filename: 'lake-192990_640.jpg'}
                                          } }
    end
    assert_redirected_to sign_in_user_path
  end
  
  
  test "should redirect destroy when not logged in" do
    assert_no_difference 'Room.count' do
      delete room_path(@room)
    end
    assert_redirected_to sign_in_user_path
  end
  
  test "should redirect posts when not logged in" do
    get posts_rooms_path
    assert_redirected_to sign_in_user_path
  end
  
    test "should get search with some keywords or minus keywords results" do
      get search_rooms_path, params: { keyword: "東京都　大阪府",
                                       column: "address"}
      assert_template 'rooms/search'
      assert_equal 0, assigns(:strict_searched_rooms).to_a.count
      assert_equal 3, assigns(:searched_rooms).to_a.count
      
      get search_rooms_path, params: { keyword: "東京都　青梅市",
                                       column: "address"}
      assert_template 'rooms/search'
      assert_equal 1, assigns(:strict_searched_rooms).to_a.count
      assert_equal 1, assigns(:searched_rooms).to_a.count
      
      get search_rooms_path, params: { keyword: "東京都　-青梅市",
                                       column: "address"}
      assert_template 'rooms/search'
      assert_equal 1, assigns(:strict_searched_rooms).to_a.count
      assert_equal 0, assigns(:searched_rooms).to_a.count
      
      get search_rooms_path, params: { keyword: "雪",
                                       column: "room_introduction"}
      assert_template 'rooms/search'
      assert_equal 1, assigns(:strict_searched_rooms).to_a.count
      assert_equal 0, assigns(:searched_rooms).to_a.count
      
      get search_rooms_path, params: { keyword: "市街地　雪",
                                       column: "room_introduction"}
      assert_template 'rooms/search'
      assert_equal 1, assigns(:strict_searched_rooms).to_a.count
      assert_equal 1, assigns(:searched_rooms).to_a.count
      
      get search_rooms_path, params: { keyword: "市街地　-雪",
                                       column: "room_introduction"}
      assert_template 'rooms/search'
      assert_equal 1, assigns(:strict_searched_rooms).to_a.count
      assert_equal 0, assigns(:searched_rooms).to_a.count
  end

end
