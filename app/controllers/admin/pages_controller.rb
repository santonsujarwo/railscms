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

    def edit; end

    def update
      if @page.update(page_params)
        redirect_to edit_admin_page_path(@page), notice: "Page updated."
      else
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

    def page_params
      params.require(:page).permit(:title, :slug, :status, :parent_id)
    end
  end
end
