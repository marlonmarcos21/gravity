class MoveTsvNameToBodyForPosts < ActiveRecord::Migration
  def up
    execute <<-SQL
      DROP TRIGGER tsvectorupdate
      ON posts
    SQL

    execute <<-SQL
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON posts FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        tsv_name, 'pg_catalog.simple', body
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
end
