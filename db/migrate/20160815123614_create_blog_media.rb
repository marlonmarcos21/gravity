class CreateBlogMedia < ActiveRecord::Migration
  def change
    create_table :blog_media do |t|
      t.attachment :source
      t.references :attachable, polymorphic: true, index: true
      t.string     :token
      t.integer    :width
      t.integer    :height

      t.timestamps null: false
    end
  end
end
