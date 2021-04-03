class CreateRecipes < ActiveRecord::Migration[6.1]
  def change
    create_table :recipes do |t|
      t.string     :title
      t.boolean    :published, default: false
      t.references :user, index: true
      t.timestamps
    end
  end
end
