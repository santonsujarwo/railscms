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
      { key: "button_label", label: "Button label", field_type: "text", group_name: "content", position: 3 },
      { key: "button_url", label: "Button URL", field_type: "url", group_name: "content", position: 4 },
      { key: "container_width", label: "Container width", field_type: "text", group_name: "layout", position: 0 },
      { key: "background", label: "Background color", field_type: "color", group_name: "style", position: 0 },
      { key: "text_color", label: "Text color", field_type: "color", group_name: "style", position: 1 },
      { key: "heading_color", label: "Heading color", field_type: "color", group_name: "style", position: 2 },
      { key: "padding_top", label: "Padding top", field_type: "text", group_name: "style", position: 3 },
      { key: "padding_bottom", label: "Padding bottom", field_type: "text", group_name: "style", position: 4 }
    ]
  },
  {
    key: "cta", name: "Call to Action", category: "content",
    settings: { "renderer" => "Sections::CtaComponent", "version" => 1 },
    fields: [
      { key: "heading", label: "Heading", field_type: "text", group_name: "content", position: 0, required: true },
      { key: "description", label: "Description", field_type: "textarea", group_name: "content", position: 1 },
      { key: "background", label: "Background color", field_type: "color", group_name: "style", position: 0 },
      { key: "text_color", label: "Text color", field_type: "color", group_name: "style", position: 1 },
      { key: "padding_top", label: "Padding top", field_type: "text", group_name: "style", position: 2 },
      { key: "padding_bottom", label: "Padding bottom", field_type: "text", group_name: "style", position: 3 }
    ]
  }
]

definitions.each do |definition|
  section_definition = SectionDefinition.find_or_initialize_by(key: definition[:key])
  section_definition.assign_attributes(
    name: definition[:name],
    category: definition[:category],
    settings: definition[:settings],
    enabled: true,
    schema_version: 1
  )
  section_definition.save!

  definition[:fields].each do |field|
    attributes = field.except(:key)
    field_definition = SectionFieldDefinition.find_or_initialize_by(
      section_definition: section_definition,
      key: field[:key]
    )
    field_definition.assign_attributes(attributes)
    field_definition.save!
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
