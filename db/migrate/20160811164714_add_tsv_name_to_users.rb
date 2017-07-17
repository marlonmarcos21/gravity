class AddTsvNameToUsers < ActiveRecord::Migration
  def up
    add_column :users, :tsv_name, :tsvector
    add_index  :users, :tsv_name, using: 'gin'

    execute <<-SQL
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON users FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        tsv_name, 'pg_catalog.simple', first_name, last_name
      );
    SQL

    now = Time.zone.now.to_s(:db)
    update("UPDATE users SET updated_at = '#{now}'")
  end

  def down
    execute <<-SQL
      DROP TRIGGER tsvectorupdate
      ON users
    SQL

    remove_index  :users, :tsv_name
    remove_column :users, :tsv_name
  end
end
