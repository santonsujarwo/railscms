class CreateContentRevisions < ActiveRecord::Migration[8.0]
  def change
    create_table :content_revisions do |t|
      t.references :record, polymorphic: true, null: false, index: true
      t.references :user, foreign_key: true
      t.string :event, null: false, default: "update"
      t.jsonb :snapshot, null: false, default: {}
      t.timestamps
    end

    add_index :content_revisions, [:record_type, :record_id, :created_at], name: "index_content_revisions_on_record_and_created_at"
  end
end
