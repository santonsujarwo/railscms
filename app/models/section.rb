class Section < ApplicationRecord
  belongs_to :page
  belongs_to :section_definition

  validates :uid, presence: true, uniqueness: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :enabled, -> { where(enabled: true) }
  scope :ordered, -> { order(:position) }

  def section_type
    section_definition.key
  end
end
