class CreateSectionFieldDefinitions < ActiveRecord::Migration[8.0]
  def change
    create_table :section_field_definitions do |t|
      t.references :section_definition, null: false, foreign_key: true
      t.string :key, null: false
      t.string :label, null: false
      t.string :field_type, null: false
      t.string :group_name, null: false, default: "content"
      t.jsonb :settings, null: false, default: {}
      t.integer :position, null: false, default: 0
      t.boolean :required, null: false, default: false
      t.boolean :enabled, null: false, default: true
      t.timestamps
    end
    add_index :section_field_definitions, %i[section_definition_id key], unique: true, name: "idx_section_fields_on_definition_and_key"
    add_index :section_field_definitions, %i[section_definition_id position], name: "idx_section_fields_on_definition_and_position"
  end
end
