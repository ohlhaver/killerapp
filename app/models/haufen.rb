class Haufen < ActiveRecord::Base
  belongs_to :hsession
  has_many :rawstories
  has_one  :haufens_story_image
end
