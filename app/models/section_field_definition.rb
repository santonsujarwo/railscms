class SectionFieldDefinition < ApplicationRecord
  FIELD_TYPES = %w[text textarea wysiwyg url email number boolean color].freeze
  GROUP_NAMES = %w[content layout style responsive].freeze

  belongs_to :section_definition

  validates :key, :label, presence: true
  validates :key, format: { with: /\A[a-z][a-z0-9_]*\z/ }
  validates :key, uniqueness: { scope: :section_definition_id }
  validates :field_type, inclusion: { in: FIELD_TYPES }
  validates :group_name, inclusion: { in: GROUP_NAMES }
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
