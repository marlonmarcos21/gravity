class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string     :title
      t.text       :body
      t.boolean    :published
      t.references :user,     index: true

      t.timestamps null: false
    end
  end
end
