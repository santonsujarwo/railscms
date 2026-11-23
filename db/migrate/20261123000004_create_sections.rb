class CreateSections < ActiveRecord::Migration[8.0]
  def change
    create_table :sections do |t|
      t.references :page, null: false, foreign_key: true
      t.references :section_definition, null: false, foreign_key: true
      t.uuid :uid, null: false
      t.integer :position, null: false, default: 0
      t.boolean :enabled, null: false, default: true
      t.integer :schema_version, null: false, default: 1
      t.jsonb :content, null: false, default: {}
      t.jsonb :layout, null: false, default: {}
      t.jsonb :style, null: false, default: {}
      t.jsonb :responsive, null: false, default: {}
      t.timestamps
    end
    add_index :sections, :uid, unique: true
    add_index :sections, %i[page_id position]
  end
end
