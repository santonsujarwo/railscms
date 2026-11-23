module Admin
  class SectionsController < ApplicationController
    before_action :set_page
    before_action :set_section, only: %i[edit update destroy move toggle]

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
        submitted_values = raw_values.permit(*allowed_keys).to_h
        # Merge rather than replace so disabled/retired field data remains recoverable.
        attributes[group] = (@section.public_send(group) || {}).merge(submitted_values)
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

    def move
      ordered = @page.sections.ordered.to_a
      current_index = ordered.index(@section)
      target_index = params[:direction] == "up" ? current_index - 1 : current_index + 1
      return redirect_to edit_admin_page_path(@page) if target_index.negative? || target_index >= ordered.length

      ordered[current_index], ordered[target_index] = ordered[target_index], ordered[current_index]
      Page.transaction do
        ordered.each_with_index { |item, index| item.update!(position: index) }
      end
      redirect_to edit_admin_page_path(@page), notice: "Section order updated."
    end

    def toggle
      @section.update!(enabled: !@section.enabled?)
      redirect_to edit_admin_page_path(@page), notice: "Section visibility updated."
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
