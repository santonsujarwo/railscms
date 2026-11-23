module Sections
  class CtaComponent < ViewComponent::Base
    def initialize(section:)
      @content = section.content || {}
    end

    def call
      content_tag :section, class: "bg-slate-900 px-6 py-16 text-white" do
        content_tag(:div, class: "mx-auto max-w-5xl text-center") do
          safe_join([
            content_tag(:h2, @content["heading"], class: "text-3xl font-bold"),
            content_tag(:p, @content["description"], class: "mt-4 text-slate-300") if @content["description"].present?
          ].compact)
        end
      end
    end
  end
end
