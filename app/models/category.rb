class Category < ApplicationRecord
  belongs_to :parent, class_name: "Category", optional: true
  has_many :children, class_name: "Category", foreign_key: :parent_id, dependent: :nullify
  has_many :posts, dependent: :nullify

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  before_validation :generate_slug

  scope :enabled, -> { where(enabled: true) }

  private

  def generate_slug
    self.slug = (slug.presence || name).to_s.parameterize if name.present? || slug.present?
  end
end
