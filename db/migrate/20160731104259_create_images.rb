class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.attachment :source
      t.references :attachable, polymorphic: true, index: true
      t.boolean    :main_image, default: false

      t.timestamps null: false
    end
  end
end
