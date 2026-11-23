module Admin
  class FieldDefinitionsController < ApplicationController
    before_action :set_section_definition
    before_action :set_field_definition, only: %i[update destroy]

    def create
      @field_definition = @section_definition.field_definitions.build(field_params)
      if @field_definition.save
        redirect_to edit_admin_section_definition_path(@section_definition), notice: "Custom field added."
      else
        redirect_to edit_admin_section_definition_path(@section_definition), alert: @field_definition.errors.full_messages.to_sentence
      end
    end

    def update
      if @field_definition.update(field_params.except(:key))
        redirect_to edit_admin_section_definition_path(@section_definition), notice: "Field updated."
      else
        redirect_to edit_admin_section_definition_path(@section_definition), alert: @field_definition.errors.full_messages.to_sentence
      end
    end

    def destroy
      @field_definition.update!(enabled: false)
      redirect_to edit_admin_section_definition_path(@section_definition), notice: "Field disabled. Existing content is preserved."
    end

    private

    def set_section_definition
      @section_definition = SectionDefinition.find(params[:section_definition_id])
    end

    def set_field_definition
      @field_definition = @section_definition.field_definitions.find(params[:id])
    end

    def field_params
      params.require(:section_field_definition).permit(:key, :label, :field_type, :group_name, :required, :position)
    end
  end
end
