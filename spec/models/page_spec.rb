require "rails_helper"

RSpec.describe Page, type: :model do
  let(:author) { User.new(name: "Test Author", email: "author@example.com", password: "a-secure-password") }

  it "generates a slug from the title when slug is blank" do
    page = Page.new(title: "About Our Studio", author: author)
    page.valid?
    expect(page.slug).to eq("about-our-studio")
  end

  it "requires a title" do
    page = Page.new(slug: "missing-title", author: author)
    expect(page).not_to be_valid
    expect(page.errors[:title]).to include("can't be blank")
  end

  it "includes flexible section data in revision snapshots" do
    persisted_author = User.create!(
      name: "Snapshot Author",
      email: "snapshot-author@example.com",
      password: "a-secure-password"
    )
    page = Page.create!(title: "Snapshot Page", author: persisted_author)
    definition = SectionDefinition.create!(
      key: "snapshot-hero",
      name: "Snapshot Hero",
      settings: { "renderer" => "Sections::HeroComponent" }
    )
    page.sections.create!(
      section_definition: definition,
      uid: SecureRandom.uuid,
      position: 0,
      content: { "heading" => "Saved heading" },
      layout: {},
      style: {},
      responsive: {}
    )

    section_snapshot = page.revision_snapshot.fetch("sections").first
    expect(section_snapshot["section_definition_key"]).to eq("snapshot-hero")
    expect(section_snapshot.dig("content", "heading")).to eq("Saved heading")
  end
end
