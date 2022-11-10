class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.boolean :published, default: false
      t.references :user, null: false, foreign_key: true
      t.datetime :published_at
      t.string :slug, index: true
      t.timestamps
    end
  end
end
