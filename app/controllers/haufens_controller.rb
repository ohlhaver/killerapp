class HaufensController < ApplicationController

  def image
    h = Haufen.find(params[:id])
    si = s.rawstories_story_image.story_image
    response.headers['Content-Type'] = si.thumb_content_type
    # Ask the browser to cache the images
    #response.headers["Expires"] = si.created_at.to_s
    #response.headers['Cache-Control'] = "public"
    render :text => si.thumb_image_data
  end



def show
  unless read_fragment({:l => @l, :id => params[:id], :page => params[:page] || 1}) 
  fetch_stories nil
  end
end

def filter_haufen_by_opinions
  unless read_fragment({:l => @l, :id => params[:id], :page => params[:page] || 1})
  fetch_stories 1 
  end     
  render :action => 'show'
  
end

def filter_haufen_by_videos
  unless read_fragment({:l => @l, :id => params[:id], :page => params[:page] || 1})
  fetch_stories 2 
  end     
  render :action => 'show'
  
end


protected
  def fetch_stories(conditions)   
    @haufen         = Haufen.find(params[:id])
    story_ids       = @haufen.members.to_s.split(' ')*","
    @haufen_stories = []
    unless story_ids.blank?
      @haufen_stories = Rawstory.find(:all,
                                   :conditions => ["rawstories.id IN ( #{story_ids} ) and rawstory_details.is_duplicate = :false", {:false => false}],
                                   :joins      => 'inner join rawstory_details on rawstory_details.rawstory_id = rawstories.id',
                                   :include => [:rawstory_detail])
    end
    
    opinion_stories = @haufen_stories.find_all {|u| u.opinion == 1 }
    @opinion_weight = opinion_stories.size
    
    videos = @haufen_stories.find_all {|u| u.video == true }
    @videos_weight = videos.size
    
    @haufen_stories = opinion_stories if conditions == 1
    @haufen_stories = videos if conditions == 2

    @haufen_stories.each do |story|
      age = ((Time.new - story.created_at)/3600).to_i 
      age = 1 if age < 1
      age = (100*(1/(age**(0.33)))).to_i 

      quality_value = story.rawstory_detail.quality rescue nil
      quality_value ||= 1

      blub =  age*quality_value

      story.blub = blub    
    end                                        

    @haufen_stories = @haufen_stories.sort_by {|u| - u.blub } 
    @haufen_stories = @haufen_stories.paginate :page     => params[:page],
                                               :per_page => 5
  end
   
   
  
end








