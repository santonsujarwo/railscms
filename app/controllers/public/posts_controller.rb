module Public
  class PostsController < ApplicationController
    def show
      @post = Post.visible.find_by!(slug: params[:slug])
    end
  end
end
