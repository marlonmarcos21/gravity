class RemoveFirstAndLastNamesInUserProfiles < ActiveRecord::Migration
  def change
    remove_column :user_profiles, :first_name, :string
    remove_column :user_profiles, :last_name, :string
  end
end
