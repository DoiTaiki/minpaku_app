require 'test_helper'

class RoomsPostsTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @user = users(:michael)
    31.times do |n|
      @room = @user.rooms.build(name: Faker::Lorem.sentence(word_count: 1), 
                                room_introduction: Faker::Lorem.sentence(word_count: 1),
                                price: 1000,
                                address: Faker::Lorem.unique.sentence(word_count: 1) + "city",
                                )
      @room.image.attach(io: File.open('./test/fixtures/files/images/lake-192990_640.jpg'), filename: 'lake-192990_640.jpg')
      @room.save!
    end
  end
  
  test "posts display" do
    log_in_as(@user)
    get posts_rooms_path
    assert_template 'rooms/posts'
    assert_match @user.rooms.count.to_s, response.body
    assert_not_equal 0, @user.rooms.count
    assert_select 'div.pagination', count:2
    @user.rooms.paginate(page: 1).each do |room|
      assert_select "a[href=?]", room_path(room.id), count: 2
      assert room.image.attached?
      assert_match room.name, response.body
      assert_match room.room_introduction, response.body
      assert_match room.price.to_s, response.body
      assert_match room.created_at.to_s, response.body
    end
  end
end
