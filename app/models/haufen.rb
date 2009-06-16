class Haufen < ActiveRecord::Base
  belongs_to :hsession
  has_many :rawstories
  has_one  :haufens_story_image

  def image_story
    image_story_id == 0 ? nil : Rawstory.find(image_story_id)
  end
end
