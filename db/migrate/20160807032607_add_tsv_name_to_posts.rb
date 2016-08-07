class AddTsvNameToPosts < ActiveRecord::Migration
  def up
    add_column :posts, :tsv_name, :tsvector
    add_index  :posts, :tsv_name, using: 'gin'

    execute <<-SQL
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON posts FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        tsv_name, 'pg_catalog.simple', title
      );
    SQL

    now = Time.zone.now.to_s(:db)
    update("UPDATE posts SET updated_at = '#{now}'")
  end

  def down
    execute <<-SQL
      DROP TRIGGER tsvectorupdate
      ON posts
    SQL

    remove_index  :posts, :tsv_name
    remove_column :posts, :tsv_name
  end
end
