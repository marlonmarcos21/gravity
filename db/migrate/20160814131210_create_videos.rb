class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.attachment :source
      t.json       :source_meta
      t.references :attachable, polymorphic: true, index: true
      t.string     :token

      t.timestamps null: false
    end
  end
end
