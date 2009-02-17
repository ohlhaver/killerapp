class RawstoriesController < ApplicationController
  
# before_filter :login_required

  
  def index

  end
  
  
  def search
    query = params[:q] unless params[:q] == nil
    fetch_search_results nil, query
  end 
 
 def filter_by_opinions
  query = params[:q]
   fetch_search_results 1, query
   render :action => 'search'
 end
 
 def filter_by_videos
  query = params[:q]
   fetch_search_results 2, query
   render :action => 'search'
 end
 
   
 def show_all
   @filter = 0
   redirect_to :action => 'search'
 end
  
  
   
 def sort_by_time
   @current_user.mode = 1
   @current_user.save
   redirect_to :action => 'search'
 end
   
 def sort_by_relevance
   @current_user.mode = 0
   @current_user.save
   redirect_to :action => 'search'
 end


 def show
   fetch_stories nil
 end
 
 def filter_group_by_opinions
   fetch_stories 1      
   render :action => 'show'
 end

 protected
 def fetch_stories(conditions)   
    story = Rawstory.find(params[:id])
   
    @haufen_stories = story.haufen.rawstories.find(:all, :order => 'rawstories.id DESC')
     (@haufen_stories = @haufen_stories.find_all {|u| u.opinion == conditions }) if conditions != nil
    @haufen_stories = @haufen_stories.paginate :page => params[:page],
                                          :per_page => 8
  end


  def fetch_search_results conditions, query   
      @search = Ultrasphinx::Search.new(:query => query, 
                                        :weights => { 'title' => 2.0 })

      @rawstories = @search.results
   #   if logged_in?
  #      if @current_user.language == 3
  #        all_languages = true
  #      else
  #        all_languages = false
  #      end
  #    end
        
   #   unless all_languages == true
   unless @i == 1
        if @language == 2
          @rawstories = @rawstories.find_all{|v| v.language == 2 }
        else 
          @rawstories = @rawstories.find_all{|v| v.language == 1 }
        end
      end
      @matches = @search.response[:matches]

      counter = 0
      @rawstories.each do |story|
      weight = (@matches[counter])[:weight]  
      age = ((Time.new - story.created_at)/3600).to_i 
      age = 1 if age < 1
      age = (100*(1/(age**(0.33)))).to_i 

      blub = age*weight/100

      story.blub = blub    
      counter = counter + 1
      end                                            
      
      @rawstories = @rawstories.sort_by {|u| - u.blub }  
      opinion_stories = @rawstories.find_all{|v| v.opinion == 1 } 
      @opinion_weight = opinion_stories.size
      video_stories = @rawstories.find_all{|v| v.video == true }   
      @videos_weight = video_stories.size
      @rawstories = opinion_stories if conditions == 1
      @rawstories = video_stories if conditions == 2
      @rawstories = @rawstories.paginate  :page => params[:page],
                                          :per_page => 5
      
    end

   
 
 
  
end
