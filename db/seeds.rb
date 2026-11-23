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

GlobalStyle.find_or_create_by!(name: "Default") do |style|
  style.active = true
  style.tokens = {
    "colors" => { "primary" => "#002B3E", "secondary" => "#F59E0B", "text" => "#333333", "background" => "#FFFFFF" },
    "typography" => { "heading" => { "font_family" => "Urbanist", "font_weight" => 700 }, "body" => { "font_family" => "DM Sans", "font_weight" => 400 } },
    "layout" => { "container_width" => "1200px", "gutter" => "30px", "section_spacing" => "80px" }
  }
end
