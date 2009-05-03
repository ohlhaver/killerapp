class HaufensController < ApplicationController



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
                                      :conditions => "id IN ( #{story_ids} )",
                                      :include => [:rawstory_detail])
    end
    
    opinion_stories = @haufen_stories.find_all {|u| u.opinion == 1 }
    @opinion_weight = opinion_stories.size
    
    videos = @haufen_stories.find_all {|u| u.video == true }
    @videos_weight = videos.size
    
    @haufen_stories = opinion_stories if conditions == 1
    @haufen_stories = videos if conditions == 2
    story_ids = @haufen_stories.collect{|s| s.id}.uniq*","
    unless story_ids.blank?
      qualities = RawstoryDetail.find(:all,
                                      :conditions => "rawstory_id IN ( #{story_ids} )",
                                      :select     => "rawstory_id, quality")
      qualities_hashed = qualities.group_by{|q| q.rawstory_id}
    end

    @haufen_stories.each do |story|
      age = ((Time.new - story.created_at)/3600).to_i 
      age = 1 if age < 1
      age = (100*(1/(age**(0.33)))).to_i 

      quality_value = qualities_hashed[story.id].first.quality rescue nil
      quality_value ||= 1

      blub =  age*quality_value

      story.blub = blub    
    end                                        

    @haufen_stories = @haufen_stories.sort_by {|u| - u.blub } 
    @haufen_stories = @haufen_stories.paginate :page     => params[:page],
                                               :per_page => 5
  end
   
   
  
end








