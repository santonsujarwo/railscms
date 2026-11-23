class SectionFieldDefinition < ApplicationRecord
  FIELD_TYPES = %w[text textarea wysiwyg image gallery url email number boolean select color repeater group relationship].freeze
  GROUP_NAMES = %w[content layout style responsive].freeze

  belongs_to :section_definition

  validates :key, :label, presence: true
  validates :key, uniqueness: { scope: :section_definition_id }
  validates :field_type, inclusion: { in: FIELD_TYPES }
  validates :group_name, inclusion: { in: GROUP_NAMES }
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
