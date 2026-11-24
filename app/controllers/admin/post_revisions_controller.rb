module Admin
  class PostRevisionsController < ApplicationController
    before_action :set_post
    before_action :set_revision

    def restore
      attributes = @revision.snapshot.slice(
        "title", "slug", "excerpt", "body", "status", "published_at",
        "category_id", "featured_media_asset_id", "seo_title", "seo_description", "canonical_url", "noindex"
      )
      @post.update!(attributes)
      ContentRevision.capture!(@post, user: current_user, event: "restore")
      redirect_to edit_admin_post_path(@post), notice: "Post revision restored."
    end

    private

    def set_post
      @post = Post.find(params[:post_id])
    end

    def set_revision
      @revision = @post.content_revisions.find(params[:id])
    end
  end
end
