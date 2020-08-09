class RemoveSourceFromVideos < ActiveRecord::Migration[6.0]
  def change
    remove_attachment :videos, :source
  end
end
