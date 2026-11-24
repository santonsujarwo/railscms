module Admin
  class PageRevisionsController < ApplicationController
    before_action :set_page
    before_action :set_revision

    def restore
      snapshot = @revision.snapshot
      attributes = snapshot.slice(
        "title", "slug", "status", "parent_id", "seo_title",
        "seo_description", "canonical_url", "noindex"
      )

      Page.transaction do
        @page.update!(attributes)
        restore_sections(snapshot.fetch("sections")) if snapshot.key?("sections")
        ContentRevision.capture!(@page, user: current_user, event: "restore")
      end

      redirect_to edit_admin_page_path(@page), notice: "Page revision restored."
    end

    private

    def set_page
      @page = Page.find(params[:page_id])
    end

    def set_revision
      @revision = @page.content_revisions.find(params[:id])
    end

    def restore_sections(section_snapshots)
      @page.sections.destroy_all

      section_snapshots.each do |item|
        definition = SectionDefinition.find_by!(key: item.fetch("section_definition_key"))
        @page.sections.create!(
          section_definition: definition,
          uid: item["uid"].presence || SecureRandom.uuid,
          position: item.fetch("position", 0),
          enabled: item.fetch("enabled", true),
          schema_version: item.fetch("schema_version", 1),
          content: item.fetch("content", {}),
          layout: item.fetch("layout", {}),
          style: item.fetch("style", {}),
          responsive: item.fetch("responsive", {})
        )
      end
    end
  end
end
