require "rails_helper"

RSpec.describe Category, type: :model do
  it "generates a slug from the category name" do
    category = Category.new(name: "Company News")
    category.valid?
    expect(category.slug).to eq("company-news")
  end

  it "requires a name" do
    expect(Category.new).not_to be_valid
  end
end
