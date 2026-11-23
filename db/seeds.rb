admin_email = ENV.fetch("ADMIN_EMAIL", "admin@example.com")
admin_password = ENV["ADMIN_PASSWORD"]

if admin_password.present?
  User.find_or_create_by!(email: admin_email) do |user|
    user.name = "Administrator"
    user.password = admin_password
    user.password_confirmation = admin_password
    user.role = "administrator"
  end
end

definitions = [
  {
    key: "hero", name: "Hero Section", category: "content",
    settings: { "renderer" => "Sections::HeroComponent", "version" => 1 },
    fields: [
      { key: "eyebrow", label: "Eyebrow", field_type: "text", group_name: "content", position: 0 },
      { key: "heading", label: "Heading", field_type: "text", group_name: "content", position: 1, required: true },
      { key: "description", label: "Description", field_type: "textarea", group_name: "content", position: 2 },
      { key: "button", label: "Button", field_type: "group", group_name: "content", position: 3, settings: { "fields" => [{ "key" => "label", "type" => "text" }, { "key" => "url", "type" => "url" }] } },
      { key: "background", label: "Background", field_type: "color", group_name: "style", position: 4 }
    ]
  },
  {
    key: "cta", name: "Call to Action", category: "content",
    settings: { "renderer" => "Sections::CtaComponent", "version" => 1 },
    fields: [
      { key: "heading", label: "Heading", field_type: "text", group_name: "content", position: 0, required: true },
      { key: "description", label: "Description", field_type: "textarea", group_name: "content", position: 1 }
    ]
  }
]

definitions.each do |definition|
  section_definition = SectionDefinition.find_or_create_by!(key: definition[:key]) do |record|
    record.name = definition[:name]
    record.category = definition[:category]
    record.settings = definition[:settings]
  end

  definition[:fields].each do |field|
    key = field.delete(:key)
    SectionFieldDefinition.find_or_create_by!(section_definition: section_definition, key: key) do |record|
      record.assign_attributes(field)
    end
  end
end

GlobalStyle.find_or_create_by!(name: "Default") do |style|
  style.active = true
  style.tokens = {
    "colors" => { "primary" => "#002B3E", "secondary" => "#F59E0B", "text" => "#333333", "background" => "#FFFFFF" },
    "typography" => { "heading" => { "font_family" => "Urbanist", "font_weight" => 700 }, "body" => { "font_family" => "DM Sans", "font_weight" => 400 } },
    "layout" => { "container_width" => "1200px", "gutter" => "30px", "section_spacing" => "80px" }
  }
end
