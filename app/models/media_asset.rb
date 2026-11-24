class MediaAsset < ApplicationRecord
  belongs_to :uploaded_by, class_name: "User"
  has_one_attached :file

  validates :alt_text, length: { maximum: 500 }
  validate :file_must_be_attached
  validate :file_must_be_an_image
  validate :file_size_within_limit

  scope :recent, -> { order(created_at: :desc) }

  private

  def file_must_be_attached
    errors.add(:file, "must be attached") unless file.attached?
  end

  def file_must_be_an_image
    return unless file.attached?

    allowed_types = %w[image/jpeg image/png image/webp image/gif image/avif]
    errors.add(:file, "must be a JPEG, PNG, WebP, GIF or AVIF image") unless allowed_types.include?(file.blob.content_type)
  end

  def file_size_within_limit
    return unless file.attached?

    errors.add(:file, "must be smaller than 15 MB") if file.blob.byte_size > 15.megabytes
  end
end
