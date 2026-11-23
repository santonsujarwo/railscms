module Admin
  class SectionDefinitionsController < ApplicationController
    def index
      @section_definitions = SectionDefinition.order(:category, :name)
    end

    def edit
      @section_definition = SectionDefinition.find(params[:id])
      @field_definitions = @section_definition.field_definitions
    end
  end
end
