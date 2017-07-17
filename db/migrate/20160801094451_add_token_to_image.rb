class AddTokenToImage < ActiveRecord::Migration
  def change
    add_column :images, :token, :string, index: true
  end
end
