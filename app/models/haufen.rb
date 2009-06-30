class Haufen < ActiveRecord::Base
  belongs_to :hsession
  has_many :rawstories
  has_one  :haufens_story_image

  def image_story
    image_story_id == 0 ? nil : Rawstory.find(image_story_id)
  end

  def top_stories(limit=nil)
    story_ids_a = top_story_ids.split(',')
    story_ids_a = story_ids_a[0,limit] unless limit.blank?
    return [] if story_ids_a.blank?

    story_ids_sql = story_ids_a*','
    stories = Rawstory.find(:all, :conditions => "id IN ( #{story_ids_sql} )")
    stories_h = stories.group_by{|s| s.id}
    sorted_stories = story_ids_a.collect{|id_s| stories_h[id_s.to_i]}
    return sorted_stories
  end
end
