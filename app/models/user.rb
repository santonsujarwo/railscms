class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  enum :role, { author: "author", editor: "editor", administrator: "administrator" }, default: :author
  has_many :pages, foreign_key: :author_id, dependent: :nullify
end
