class CreateGlobalStyles < ActiveRecord::Migration[8.0]
  def change
    create_table :global_styles do |t|
      t.string :name, null: false
      t.jsonb :tokens, null: false, default: {}
      t.boolean :active, null: false, default: false
      t.timestamps
    end
    add_index :global_styles, :active
  end
end
