module Admin
  class DashboardController < ApplicationController
    def index
      @pages_count = Page.count
      @published_pages_count = Page.published.count
      @draft_pages_count = Page.draft.count
    end
  end
end
