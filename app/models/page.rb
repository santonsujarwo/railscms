class Page < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :parent, class_name: "Page", optional: true
  has_many :children, class_name: "Page", foreign_key: :parent_id, dependent: :nullify
  has_many :sections, -> { order(:position) }, dependent: :destroy

  enum :status, { draft: "draft", published: "published", archived: "archived" }, default: :draft
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  before_validation { self.slug = slug.to_s.parameterize if slug.present? }
end
