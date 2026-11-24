module Admin
  class PostsController < ApplicationController
    before_action :set_post, only: %i[show edit update destroy]

    def index
      @posts = Post.includes(:author, :category).order(updated_at: :desc)
    end

    def new
      @post = Post.new(status: "draft")
      load_categories
    end

    def create
      @post = Post.new(post_params.merge(author: current_user))
      if @post.save
        ContentRevision.capture!(@post, user: current_user, event: "create")
        redirect_to edit_admin_post_path(@post), notice: "Post created."
      else
        load_categories
        render :new, status: :unprocessable_entity
      end
    end

    def show
      redirect_to edit_admin_post_path(@post)
    end

    def edit
      load_categories
      @revisions = @post.content_revisions.includes(:user).recent.limit(10)
    end

    def update
      if @post.update(post_params)
        ContentRevision.capture!(@post, user: current_user)
        redirect_to edit_admin_post_path(@post), notice: "Post updated."
      else
        load_categories
        @revisions = @post.content_revisions.includes(:user).recent.limit(10)
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @post.destroy
      redirect_to admin_posts_path, notice: "Post deleted."
    end

    private

    def set_post
      @post = Post.find(params[:id])
    end

    def load_categories
      @categories = Category.enabled.order(:name)
    end

    def post_params
      params.require(:post).permit(:title, :slug, :excerpt, :body, :status, :published_at, :category_id,
                                   :seo_title, :seo_description, :canonical_url, :noindex)
    end
  end
end
