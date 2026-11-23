class GlobalStyle < ApplicationRecord
  validates :name, presence: true
  validates :tokens, presence: true
  scope :active, -> { where(active: true) }

  before_save :deactivate_other_styles, if: :active?

  private

  def deactivate_other_styles
    GlobalStyle.where.not(id: id).update_all(active: false)
  end
end
