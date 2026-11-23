class CreateSectionDefinitions < ActiveRecord::Migration[8.0]
  def change
    create_table :section_definitions do |t|
      t.string :key, null: false
      t.string :name, null: false
      t.string :category, null: false, default: "content"
      t.text :description
      t.boolean :enabled, null: false, default: true
      t.integer :schema_version, null: false, default: 1
      t.jsonb :settings, null: false, default: {}
      t.timestamps
    end
    add_index :section_definitions, :key, unique: true
  end
end
