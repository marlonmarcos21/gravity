class AddTsvNameToBlogs < ActiveRecord::Migration
  def up
    add_column :blogs, :tsv_name, :tsvector
    add_index  :blogs, :tsv_name, using: 'gin'

    execute <<-SQL
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON blogs FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        tsv_name, 'pg_catalog.simple', title
      );
    SQL

    now = Time.zone.now.to_s(:db)
    update("UPDATE blogs SET updated_at = '#{now}'")
  end

  def down
    execute <<-SQL
      DROP TRIGGER tsvectorupdate
      ON blogs
    SQL

    remove_index  :blogs, :tsv_name
    remove_column :blogs, :tsv_name
  end
end
