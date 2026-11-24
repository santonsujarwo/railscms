require "rails_helper"

RSpec.describe Post, type: :model do
  let(:author) do
    User.create!(name: "Test Author", email: "post-author@example.com", password: "a-secure-password")
  end

  it "generates a slug from the title" do
    post = Post.new(title: "A Practical CMS Guide", author: author)
    post.valid?
    expect(post.slug).to eq("a-practical-cms-guide")
  end

  it "requires a title" do
    post = Post.new(slug: "missing-title", author: author)
    expect(post).not_to be_valid
    expect(post.errors[:title]).to include("can't be blank")
  end

  it "rejects a non-http canonical URL" do
    post = Post.new(title: "Canonical URL", author: author, canonical_url: "javascript:alert(1)")
    expect(post).not_to be_valid
  end
end
