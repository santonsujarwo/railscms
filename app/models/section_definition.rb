class SectionDefinition < ApplicationRecord
  has_many :sections, dependent: :restrict_with_error
  has_many :field_definitions, -> { where(enabled: true).order(:position) },
           class_name: "SectionFieldDefinition", dependent: :destroy

  validates :key, presence: true, uniqueness: true
  validates :name, presence: true
  validates :settings, presence: true
end
