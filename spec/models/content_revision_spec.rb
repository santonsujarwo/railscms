require "rails_helper"

RSpec.describe ContentRevision, type: :model do
  it "stores a snapshot of a page and its editor" do
    user = User.create!(name: "Editor", email: "revision-editor@example.com", password: "a-secure-password")
    page = Page.create!(title: "Revision Test", author: user)

    revision = described_class.capture!(page, user: user)

    expect(revision.record).to eq(page)
    expect(revision.user).to eq(user)
    expect(revision.snapshot["title"]).to eq("Revision Test")
  end
end
