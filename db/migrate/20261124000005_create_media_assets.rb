class CreateMediaAssets < ActiveRecord::Migration[8.0]
  def change
    create_table :media_assets do |t|
      t.string :alt_text
      t.string :caption
      t.references :uploaded_by, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
