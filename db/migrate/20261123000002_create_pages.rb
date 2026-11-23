class CreatePages < ActiveRecord::Migration[8.0]
  def change
    create_table :pages do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.string :status, null: false, default: "draft"
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :parent, foreign_key: { to_table: :pages }
      t.datetime :published_at
      t.timestamps
    end
    add_index :pages, :slug, unique: true
    add_index :pages, :status
  end
end
