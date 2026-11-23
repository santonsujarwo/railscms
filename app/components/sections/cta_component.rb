module Sections
  class CtaComponent < ViewComponent::Base
    def initialize(section:)
      @content = section.content || {}
      @style = section.style || {}
    end

    def call
      content_tag :section, class: "px-6 text-center", style: section_style do
        content_tag(:div, class: "mx-auto max-w-5xl") do
          safe_join([
            content_tag(:h2, @content["heading"], class: "text-3xl font-bold"),
            content_tag(:p, @content["description"], class: "mt-4 text-lg") if @content["description"].present?
          ].compact)
        end
      end
    end

    private

    def section_style
      values = {
        "background-color" => safe_color(@style["background"]),
        "color" => safe_color(@style["text_color"]),
        "padding-top" => safe_spacing(@style["padding_top"]) || "64px",
        "padding-bottom" => safe_spacing(@style["padding_bottom"]) || "64px"
      }
      values.map { |key, value| "#{key}: #{value}" }.join("; ")
    end

    def safe_color(value)
      value if value.to_s.match?(/\A#(?:[0-9a-fA-F]{3}|[0-9a-fA-F]{6})\z/)
    end

    def safe_spacing(value)
      value if value.to_s.match?(/\A(?:0|\d+(?:\.\d+)?(?:px|rem|em|%))\z/)
    end
  end
end
