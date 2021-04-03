class AddUserToRecipeMedia < ActiveRecord::Migration[6.1]
  def change
    add_reference :recipe_media, :user, index: true
  end
end
