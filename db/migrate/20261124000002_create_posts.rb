class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :excerpt
      t.text :body
      t.string :status, null: false, default: "draft"
      t.datetime :published_at
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :category, foreign_key: true
      t.string :seo_title
      t.text :seo_description
      t.string :canonical_url
      t.boolean :noindex, null: false, default: false
      t.timestamps
    end

    add_index :posts, :slug, unique: true
    add_index :posts, [:status, :published_at]
  end
end
