module Admin
  class PageRevisionsController < ApplicationController
    before_action :set_page
    before_action :set_revision

    def restore
      attributes = @revision.snapshot.slice(
        "title", "slug", "status", "parent_id", "seo_title",
        "seo_description", "canonical_url", "noindex"
      )
      @page.update!(attributes)
      ContentRevision.capture!(@page, user: current_user, event: "restore")
      redirect_to edit_admin_page_path(@page), notice: "Page revision restored."
    end

    private

    def set_page
      @page = Page.find(params[:page_id])
    end

    def set_revision
      @revision = @page.content_revisions.find(params[:id])
    end
  end
end
