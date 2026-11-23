module Rendering
  class SectionRenderer
    def initialize(section:)
      @section = section
    end

    def component
      Sections::Registry.fetch(@section.section_type)
    end

    def renderable?
      @section.enabled? && Sections::Registry.registered?(@section.section_type)
    end
  end
end
