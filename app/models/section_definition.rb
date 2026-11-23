class SectionDefinition < ApplicationRecord
  has_many :sections, dependent: :restrict_with_error
  validates :key, presence: true, uniqueness: true
  validates :name, presence: true
  validates :settings, presence: true
end
