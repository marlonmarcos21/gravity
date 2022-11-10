class CreateRsvps < ActiveRecord::Migration[6.1]
  def change
    create_table :rsvps do |t|
      t.references :event, null: false, foreign_key: true
      t.string :name, null: false
      t.string :email
      t.string :phone
      t.text   :notes
      t.string :status, null: false
      t.references :parent
      t.timestamps
    end
  end
end
