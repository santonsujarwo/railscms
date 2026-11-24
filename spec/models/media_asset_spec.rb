require "rails_helper"

RSpec.describe MediaAsset, type: :model do
  let(:user) do
    User.create!(name: "Media Editor", email: "media-editor@example.com", password: "a-secure-password")
  end

  it "requires an uploaded image" do
    asset = described_class.new(uploaded_by: user)
    expect(asset).not_to be_valid
    expect(asset.errors[:file]).to include("must be attached")
  end

  it "rejects a non-image upload" do
    asset = described_class.new(uploaded_by: user)
    asset.file.attach(
      io: StringIO.new("plain text"),
      filename: "notes.txt",
      content_type: "text/plain"
    )

    expect(asset).not_to be_valid
    expect(asset.errors[:file].join).to match(/must be a JPEG/)
  end
end
