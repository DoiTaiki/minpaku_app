class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room
  default_scope -> { order(created_at: :desc) }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :number_of_people, presence: true
  validates :user_id, presence: true
  validates :room_id, presence: true
end
