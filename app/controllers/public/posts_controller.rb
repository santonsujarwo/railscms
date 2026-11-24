module Public
  class PostsController < ApplicationController
    def show
      @post = Post.visible.find_by!(slug: params[:slug])
      head :not_found if @post.noindex? && request.format.json?
    end
  end
end
