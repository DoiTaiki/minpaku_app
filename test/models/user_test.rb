require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     self_introduction: "hello!",
                     password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "      "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "      "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w(
      user@example.com USER@foo.COM A_US-ER@foo.bar.org
      first.last@foo.jp alice+bob@baz.cn
    )
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w(
      user@example,com user_at_foo.org user.name@example.
      foo@bar_baz.com foo@bar+baz.com
    )
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email address should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should be have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "self_introduction should not be too long" do
    @user.self_introduction = "a" * 256
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end

  test "associated rooms should be destroyed" do
    @user.save
    @user.rooms.create!(name: "A city's seaside",
                        room_introduction: "beautiful seaside",
                        price: 2000,
                        address: "A city 1-1-1",
                        image: { io: File.open('./test/fixtures/files/images/lake-192990_640.jpg'), filename: 'lake-192990_640.jpg' })
    assert_difference 'Room.count', -1 do
      @user.destroy
    end
  end

  test "associated reservations should be destroyed" do
    @user.save
    @user.reservations.create!(start_date: Faker::Date.between(from: '2020-11-23', to: '2020-11-30'),
                               end_date: Faker::Date.between(from: '2020-12-01', to: '2020-12-10'),
                               number_of_people: 2,
                               room_id: rooms(:one).id)
    assert_difference 'Reservation.count', -1 do
      @user.destroy
    end
  end
end
