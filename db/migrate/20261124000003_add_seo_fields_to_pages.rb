class AddSeoFieldsToPages < ActiveRecord::Migration[8.0]
  def change
    add_column :pages, :seo_title, :string
    add_column :pages, :seo_description, :text
    add_column :pages, :canonical_url, :string
    add_column :pages, :noindex, :boolean, null: false, default: false
  end
end
