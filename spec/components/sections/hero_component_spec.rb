require "rails_helper"

RSpec.describe Sections::HeroComponent, type: :component do
  let(:section) do
    instance_double(Section, content: {}, layout: {}, style: {})
  end

  subject(:component) { described_class.new(section: section) }

  it "allows relative paths" do
    expect(component.send(:safe_button_url, "/contact")).to eq("/contact")
  end

  it "allows fragment links" do
    expect(component.send(:safe_button_url, "#contact")).to eq("#contact")
  end

  it "rejects protocol-relative external URLs" do
    expect(component.send(:safe_button_url, "//example.com")).to be_nil
  end

  it "rejects unsafe URL schemes" do
    expect(component.send(:safe_button_url, "javascript:alert(1)")).to be_nil
  end
end
