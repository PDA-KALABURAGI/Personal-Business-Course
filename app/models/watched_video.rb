class WatchedVideo < ApplicationRecord
  belongs_to :user
  belongs_to :tut
end
