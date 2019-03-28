class Micropost < ApplicationRecord
  belongs_to :user
  scope :order_desc, ->{order created_at: :desc}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.content.maximum}
  validate :picture_size
  scope :find_user_followed, (lambda do |id|
    following_ids = "SELECT followed_id FROM relationships
      WHERE  follower_id = :user_id"
    where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end)
  private

  # Validates the size of an uploaded picture.
  def picture_size
    return unless picture.size > Settings.microposts.size.megabytes
    errors.add :picture, t(".picture")
  end
end
