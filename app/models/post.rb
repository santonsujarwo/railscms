class Post < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :category, optional: true
  belongs_to :featured_media_asset, class_name: "MediaAsset", optional: true
  has_many :content_revisions, as: :record, dependent: :destroy

  enum :status, { draft: "draft", published: "published", archived: "archived" }, default: :draft

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :canonical_url, format: { with: /\Ahttps?:\/\//i }, allow_blank: true
  before_validation :generate_slug
  before_validation :set_published_at, if: :will_save_change_to_status?

  scope :visible, -> { published.where("published_at IS NULL OR published_at <= ?", Time.current) }

  def meta_title
    seo_title.presence || title
  end

  def meta_description
    seo_description.presence || excerpt
  end

  private

  def generate_slug
    source = slug.presence || title
    self.slug = source.to_s.parameterize if source.present?
  end

  def set_published_at
    self.published_at ||= Time.current if published?
  end
end
