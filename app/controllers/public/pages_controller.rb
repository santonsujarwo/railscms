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
      content_for :title, @page.seo_title.presence || @page.title
      content_for :meta_description, @page.seo_description if @page.seo_description.present?
      content_for :canonical_url, @page.canonical_url.presence || request.original_url
      content_for :robots, (@page.noindex? ? "noindex, nofollow" : "index, follow")
    end
  end
end
