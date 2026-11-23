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
end
