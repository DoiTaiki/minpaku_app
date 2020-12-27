class Room < ApplicationRecord
  belongs_to :user
  has_many :reservations, dependent: :destroy
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
  
  def display_image(height=300, width=300)
    image.variant(resize_to_limit: [height, width])
  end
  
  def self.search(search_word, column)
    self.where(["#{column} LIKE ?", "%#{search_word}%"])
  end
  
  #def self.search(search_words, column)
    #search_array = []
    #search_words.each do |search_word|
      #search_array.push("%#{search_word}%")
    #end
    #self.where(["#{column} LIKE ?", search_array])
  #end

  
  def self.minus_search(search_word, column)
    self.where(["#{column} NOT LIKE ?", "%#{search_word.delete_prefix('-')}%"])
  end
end
