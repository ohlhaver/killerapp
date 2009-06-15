class HaufensStoryImage < ActiveRecord::Base
  belongs_to :story_image
  belongs_to :haufen
end
