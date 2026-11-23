module Public
  class PagesController < ApplicationController
    def home
      @page = Page.find_by(slug: "home", status: "published")
      return head :not_found unless @page
      load_page
      render :show
    end

    def show
      @page = Page.find_by!(slug: params[:path], status: "published")
      load_page
    end

    private

    def load_page
      @sections = @page.sections.enabled.ordered.includes(:section_definition)
      @global_style = GlobalStyle.active.first
    end
  end
end
