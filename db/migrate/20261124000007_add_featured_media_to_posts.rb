class AddFeaturedMediaToPosts < ActiveRecord::Migration[8.0]
  def change
    add_reference :posts, :featured_media_asset,
                  foreign_key: { to_table: :media_assets },
                  index: true
  end
end
