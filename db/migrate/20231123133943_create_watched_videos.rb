class CreateWatchedVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :watched_videos do |t|
      t.references :user, null: false, foreign_key: true
      t.references :tut, null: false, foreign_key: true
      t.string :video_filename

      t.timestamps
    end
  end
end
