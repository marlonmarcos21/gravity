class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string     :title
      t.text       :body
      t.boolean    :published
      t.datetime   :published_at
      t.references :user,        index: true
      t.string     :slug

      t.timestamps null: false
    end
  end
end
