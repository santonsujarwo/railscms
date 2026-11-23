module Sections
  class HeroComponent < ViewComponent::Base
    def initialize(section:)
      @content = section.content || {}
      @style = section.style || {}
    end

    def call
      content_tag :section, class: "py-20", style: section_style do
        content_tag(:div, class: "mx-auto max-w-6xl px-6") do
          safe_join([
            content_tag(:p, @content["eyebrow"], class: "mb-3 text-sm font-semibold uppercase tracking-wider") if @content["eyebrow"].present?,
            content_tag(:h1, @content["heading"], class: "text-4xl font-bold tracking-tight md:text-6xl"),
            content_tag(:p, @content["description"], class: "mt-5 max-w-2xl text-lg leading-8") if @content["description"].present?,
            render_button
          ].compact)
        end
      end
    end

    private

    def render_button
      button = @content["button"] || {}
      return unless button["label"].present? && safe_button_url(button["url"])

      link_to button["label"], safe_button_url(button["url"]), class: "mt-8 inline-flex rounded-lg bg-slate-900 px-6 py-3 font-medium text-white"
    end

    def safe_button_url(value)
      return if value.blank?
      return value if value.start_with?("/", "#")

      uri = URI.parse(value)
      value if %w[https http mailto].include?(uri.scheme)
    rescue URI::InvalidURIError
      nil
    end

    def section_style
      background = @style["background"]
      return unless background.to_s.match?(/\A#(?:[0-9a-fA-F]{3}|[0-9a-fA-F]{6})\z/)

      "background-color: #{background};"
    end
  end
end
