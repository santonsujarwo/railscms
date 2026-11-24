class ContentRevision < ApplicationRecord
  belongs_to :record, polymorphic: true
  belongs_to :user, optional: true

  validates :event, presence: true
  validates :snapshot, presence: true

  scope :recent, -> { order(created_at: :desc) }

  def self.capture!(record, user:, event: "update")
    snapshot = record.respond_to?(:revision_snapshot) ? record.revision_snapshot : record.attributes

    create!(
      record: record,
      user: user,
      event: event,
      snapshot: snapshot
    )
  end
end
