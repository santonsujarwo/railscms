module Admin
  class PagesController < ApplicationController
    before_action :set_page, only: %i[edit update destroy]

    def index
      @pages = Page.order(updated_at: :desc)
    end

    def new
      @page = Page.new(status: "draft")
    end

    def create
      @page = Page.new(page_params.merge(author: current_user))
      if @page.save
        redirect_to edit_admin_page_path(@page), notice: "Page created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      load_editor_data
      @revisions = @page.content_revisions.includes(:user).recent.limit(10)
    end

    def update
      if @page.update(page_params)
        ContentRevision.capture!(@page, user: current_user)
        redirect_to edit_admin_page_path(@page), notice: "Page updated."
      else
        load_editor_data
        @revisions = @page.content_revisions.includes(:user).recent.limit(10)
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @page.destroy
      redirect_to admin_pages_path, notice: "Page deleted."
    end

    private

    def set_page
      @page = Page.find(params[:id])
    end

    def load_editor_data
      @sections = @page.sections.includes(:section_definition).ordered
      @section_definitions = SectionDefinition.where(enabled: true).order(:name)
    end

    def page_params
      params.require(:page).permit(:title, :slug, :status, :parent_id, :seo_title, :seo_description, :canonical_url, :noindex)
    end
  end
end
