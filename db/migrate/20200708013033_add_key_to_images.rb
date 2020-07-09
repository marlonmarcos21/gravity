class AddKeyToImages < ActiveRecord::Migration[6.0]
  def change
    add_column :images, :key, :string, index: true
  end
end
