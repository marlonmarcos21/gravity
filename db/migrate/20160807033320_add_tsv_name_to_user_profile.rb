class AddTsvNameToUserProfile < ActiveRecord::Migration
  def up
    add_column :user_profiles, :tsv_name, :tsvector
    add_index  :user_profiles, :tsv_name, using: 'gin'

    execute <<-SQL
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON user_profiles FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        tsv_name, 'pg_catalog.simple', first_name, last_name
      );
    SQL

    now = Time.zone.now.to_s(:db)
    update("UPDATE user_profiles SET updated_at = '#{now}'")
  end

  def down
    execute <<-SQL
      DROP TRIGGER tsvectorupdate
      ON user_profiles
    SQL

    remove_index  :user_profiles, :tsv_name
    remove_column :user_profiles, :tsv_name
  end
end
