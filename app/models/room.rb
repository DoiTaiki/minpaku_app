class Room < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :room_introduction, presence: true, length: { maximum: 255 }
  validates :price, presence: true, length: { maximum: 50 }
  validates :address, presence: true, length: { maximum: 255 }, uniqueness: true
  validates :image, presence: true,
                    content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
                    size:         { less_than: 5.megabytes,
                                    message: "should be less than 5MB" }
  
  def display_image
    image.variant(resize_to_limit: [300, 300])
  end
end
