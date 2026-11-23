module Sections
  class HeroComponent < ViewComponent::Base
    def initialize(section:)
      @section = section
      @content = section.content || {}
      @style = section.style || {}
      @layout = section.layout || {}
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
      return unless button["label"].present? && button["url"].present?

      link_to button["label"], button["url"], class: "mt-8 inline-flex rounded-lg bg-slate-900 px-6 py-3 font-medium text-white"
    end

    def section_style
      background = @style["background"]
      background.present? ? "background-color: #{background};" : nil
    end
  end
end
