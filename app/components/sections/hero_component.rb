module Sections
  class HeroComponent < ViewComponent::Base
    def initialize(section:)
      @content = section.content || {}
      @layout = section.layout || {}
      @style = section.style || {}
    end

    def call
      content_tag :section, class: "py-20", style: section_style do
        content_tag(:div, class: "mx-auto px-6", style: container_style) do
          elements = []
          if @content["eyebrow"].present?
            elements << content_tag(:p, @content["eyebrow"], class: "mb-3 text-sm font-semibold uppercase tracking-wider")
          end
          elements << content_tag(:h1, @content["heading"], class: "text-4xl font-bold tracking-tight md:text-6xl", style: color_declaration(@style["heading_color"]))
          if @content["description"].present?
            elements << content_tag(:p, @content["description"], class: "mt-5 max-w-2xl text-lg leading-8")
          end
          elements << render_button
          safe_join(elements.compact)
        end
      end
    end

    private

    def render_button
      url = safe_button_url(@content["button_url"])
      return unless @content["button_label"].present? && url

      link_to @content["button_label"], url, class: "mt-8 inline-flex rounded-lg bg-slate-900 px-6 py-3 font-medium text-white"
    end

    def safe_button_url(value)
      return if value.blank?
      return value if value.start_with?("/", "#")

      uri = URI.parse(value)
      value if %w[https http mailto].include?(uri.scheme)
    rescue URI::InvalidURIError
      nil
    end

    def color_declaration(value)
      return unless safe_color(value)

      "color: #{value};"
    end

    def safe_color(value)
      value if value.to_s.match?(/\A#(?:[0-9a-fA-F]{3}|[0-9a-fA-F]{6})\z/)
    end

    def safe_spacing(value)
      value if value.to_s.match?(/\A(?:0|\d+(?:\.\d+)?(?:px|rem|em|%))\z/)
    end

    def section_style
      declarations = {
        "background-color" => safe_color(@style["background"]),
        "color" => safe_color(@style["text_color"]),
        "padding-top" => safe_spacing(@style["padding_top"]) || "var(--section-spacing, 80px)",
        "padding-bottom" => safe_spacing(@style["padding_bottom"]) || "var(--section-spacing, 80px)"
      }.compact
      declarations.map { |property, value| "#{property}: #{value}" }.join("; ")
    end

    def container_style
      width = safe_spacing(@layout["container_width"])
      width ? "max-width: #{width};" : "max-width: var(--container-width, 1200px);"
    end
  end
end
