class RawstoriesStoryImage < ActiveRecord::Base
  belongs_to :story_image
  belongs_to :rawstory
end
