class Page < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :parent, class_name: "Page", optional: true
  has_many :children, class_name: "Page", foreign_key: :parent_id, dependent: :nullify
  has_many :sections, -> { order(:position) }, dependent: :destroy
  has_many :content_revisions, as: :record, dependent: :destroy

  enum :status, { draft: "draft", published: "published", archived: "archived" }, default: :draft
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :canonical_url, format: { with: /\Ahttps?:\/\//i }, allow_blank: true
  before_validation :generate_slug

  def meta_title
    seo_title.presence || title
  end

  def revision_snapshot
    page_attributes = attributes.slice(
      "title", "slug", "status", "author_id", "parent_id", "published_at",
      "seo_title", "seo_description", "canonical_url", "noindex"
    )

    page_attributes.merge(
      "sections" => sections.includes(:section_definition).ordered.map do |section|
        {
          "uid" => section.uid,
          "section_definition_key" => section.section_definition.key,
          "position" => section.position,
          "enabled" => section.enabled,
          "schema_version" => section.schema_version,
          "content" => section.content,
          "layout" => section.layout,
          "style" => section.style,
          "responsive" => section.responsive
        }
      end
    )
  end

  private

  def generate_slug
    source = slug.presence || title
    self.slug = source.to_s.parameterize if source.present?
  end
end
