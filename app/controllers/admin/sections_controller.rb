module Admin
  class SectionsController < ApplicationController
    before_action :set_page
    before_action :set_section, only: %i[edit update destroy]

    def create
      definition = SectionDefinition.where(enabled: true).find(params.require(:section_definition_id))
      section = @page.sections.create!(
        section_definition: definition,
        uid: SecureRandom.uuid,
        position: @page.sections.maximum(:position).to_i + 1,
        content: {},
        layout: {},
        style: {},
        responsive: {}
      )
      redirect_to edit_admin_page_section_path(@page, section), notice: "Section added."
    end

    def edit
      @field_groups = @section.section_definition.field_definitions.group_by(&:group_name)
    end

    def update
      attributes = {}
      %w[content layout style responsive].each do |group|
        allowed_keys = @section.section_definition.field_definitions
                                .where(group_name: group, enabled: true).pluck(:key)
        raw_values = params.require(:section).fetch(group, ActionController::Parameters.new)
        attributes[group] = raw_values.permit(*allowed_keys).to_h
      end

      missing_required = @section.section_definition.field_definitions
                                   .where(required: true)
                                   .any? { |field| attributes.fetch(field.group_name, {})[field.key].blank? }

      if missing_required
        @section.errors.add(:base, "Please complete all required fields.")
        @field_groups = @section.section_definition.field_definitions.group_by(&:group_name)
        render :edit, status: :unprocessable_entity
      elsif @section.update(attributes)
        redirect_to edit_admin_page_path(@page), notice: "Section updated."
      else
        @field_groups = @section.section_definition.field_definitions.group_by(&:group_name)
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @section.destroy
      redirect_to edit_admin_page_path(@page), notice: "Section deleted."
    end

    private

    def set_page
      @page = Page.find(params[:page_id])
    end

    def set_section
      @section = @page.sections.find(params[:id])
    end
  end
end
