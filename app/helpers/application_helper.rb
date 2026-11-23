module ApplicationHelper
  def design_token_styles(tokens)
    tokens ||= {}
    declarations = {}
    colors = tokens["colors"] || {}
    colors.each do |key, value|
      next unless %w[primary secondary text background].include?(key)
      next unless value.to_s.match?(/\A#(?:[0-9a-fA-F]{3}|[0-9a-fA-F]{6})\z/)

      declarations["--color-#{key}"] = value
    end

    typography = tokens["typography"] || {}
    { "heading" => "heading", "body" => "body" }.each do |token, key|
      settings = typography[key] || {}
      family = settings["font_family"].to_s
      if family.match?(/\A[A-Za-z0-9 _,-]{1,60}\z/)
        declarations["--font-#{token}"] = %("#{family}", sans-serif)
      end
      weight = settings["font_weight"].to_s
      declarations["--font-#{token}-weight"] = weight if weight.match?(/\A[1-9]00\z/)
    end

    layout = tokens["layout"] || {}
    { "container-width" => "container_width", "gutter" => "gutter", "section-spacing" => "section_spacing" }.each do |css_key, key|
      value = layout[key].to_s
      declarations["--#{css_key}"] = value if value.match?(/\A(?:0|\d+(?:\.\d+)?(?:px|rem|em|%))\z/)
    end

    declarations.map { |property, value| "#{property}: #{value}" }.join("; ")
  end
end
