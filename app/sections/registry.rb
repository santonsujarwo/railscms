module Sections
  class UnknownSectionError < StandardError; end

  class Registry
    COMPONENTS = {
      "hero" => "Sections::HeroComponent",
      "about" => "Sections::AboutComponent",
      "services" => "Sections::ServicesComponent",
      "features" => "Sections::FeaturesComponent",
      "testimonials" => "Sections::TestimonialsComponent",
      "cta" => "Sections::CtaComponent"
    }.freeze

    def self.registered?(key)
      COMPONENTS.key?(key.to_s)
    end

    def self.fetch(key)
      component_name = COMPONENTS[key.to_s]
      raise UnknownSectionError, "Unknown section: #{key}" unless component_name
      component_name.constantize
    end

    def self.keys
      COMPONENTS.keys
    end
  end
end
