class GroupsController < ApplicationController
  
  #before_filter :determine_date
 
      
  def index   
    unless read_fragment({:f => iphone_user_agent?, :action => 'index', :l => @l, :page => params[:page] || 1})   
    @haufens = fetch_groups nil, nil
    @top_opinions_haufens = fetch_opinions 1
    #end
    #unless read_fragment({:part => 'bottom', :action => 'index', :l => @l, :page => params[:page] || 1}) 
    @top_politics_haufens = fetch_groups 2, 1
    @top_business_haufens = fetch_groups 5, 1
    @top_culture_haufens = fetch_groups 3, 1
    @top_science_haufens = fetch_groups 4, 1
    @top_technology_haufens = fetch_groups 9, 1
    @top_sport_haufens = fetch_groups 6, 1
    @top_mixed_haufens = fetch_groups 7, 1
    
    
    end
    @top_my_searchterms={}
    if @searchterms
      @searchterms.each do |s|
        unless read_fragment({:f => iphone_user_agent?, :part => 'topic', :s => s, :f => iphone_user_agent?, :action => 'index', :l => @l, :page => params[:page] || 1})  
          @top_my_searchterms[s] = fetch_my_searchterms s
        end
      end
    end
    @top_my_authors = fetch_my_authors 
    
    
     
     # respond_to do |format|
    #      format.iphone
    #      format.html
    #  end
  end
  
  def politics
    unless read_fragment({:action => 'politics', :l => @l, :page => params[:page] || 1})   
    @haufens = fetch_groups 2, 0      
  end
    render :action => 'index'
  end
  
  def culture
    unless read_fragment({:action => 'culture', :l => @l, :page => params[:page] || 1}) 
    @haufens = fetch_groups 3, 0
    end      
    render :action => 'index'
  end
  
  def science
    unless read_fragment({:action => 'science', :l => @l, :page => params[:page] || 1}) 
    @haufens = fetch_groups 4, 0  
    end    
    render :action => 'index'
    
  end
  
  def business
    unless read_fragment({:action => 'business', :l => @l, :page => params[:page] || 1})  
    @haufens = fetch_groups 5, 0
    end    
    render :action => 'index'
    
  end

  def sport
    unless read_fragment({:action => 'sport', :l => @l, :page => params[:page] || 1})  
    @haufens = fetch_groups 6, 0
    end   
    render :action => 'index'
    
  end
  
  def mixed
    unless read_fragment({:action => 'mixed', :l => @l, :page => params[:page] || 1}) 
    @haufens = fetch_groups 7, 0  
    end    
    render :action => 'index'
    
  end
  
  def humor
    unless read_fragment({:action => 'humor', :l => @l, :page => params[:page] || 1})  
    @haufens = fetch_groups 8, 0
    end     
    render :action => 'index'
  end
  
  def technology
    unless read_fragment({:action => 'technology', :l => @l, :page => params[:page] || 1}) 
    @haufens = fetch_groups 9, 0 
    end     
    render :action => 'index'
  end

  def opinions
    unless read_fragment({:action => 'opinions', :l => @l, :page => params[:page] || 1}) 
    @haufens = fetch_opinions 0
    end 
        
    render :action => 'index'
  end


      
     protected
     def fetch_groups(conditions, home)
        right_session = Hsession.find(:last).id - 1
        haufens = Hsession.find(right_session).haufens  
        if @language == 2
          haufens = haufens.find_all{|v| v.language == 2 }
        else 
          haufens = haufens.find_all{|v| v.language == 1 }
        end
        (haufens = haufens.find_all {|u| u.topic == conditions }) if conditions != nil
        if conditions == nil
            (haufens = haufens.find_all {|u| u.topic != 6 }) 
            (haufens = haufens.find_all {|u| u.topic != 7 })
        end
        
        haufens = haufens.sort_by {|u| - u.broadness }  
        
        haufens = haufens.first(6) if conditions == nil
        haufens -= @haufens if home == 1 && @haufens != nil
        haufens = haufens.first(2) if home == 1
        #haufens = haufens.first(36)
       
        haufens = haufens.paginate :page => params[:page],
                                     :per_page => 6
        
                                   
      end
      
      def fetch_opinions(home)
        
        list = Olist.find(:last) 
        @stories =[]
       
        if @language == 2
            
          if list.de
             story_array = list.de.split(/\ /) 
             story_array.each do |story|
               @stories += Rawstory.find(story).to_a
             end
          end
         
         else
       
          if list.en
           story_array = list.en.split(/\ /) 
           story_array.each do |story|
             @stories += Rawstory.find(story).to_a
           end
          end
        end
        @stories = @stories.first(24)
        @stories = @stories.first(2) if home == 1
        haufens = @stories.paginate :page => params[:page],
                                     :per_page => 6
                                     
    end
    
    def fetch_my_authors
    if logged_in?  
     @user_stories =[]
     if @current_user.stories
      story_array = @current_user.stories.split(/\ /) if @current_user.stories
      date = Time.now.yesterday
      story_array.each do |story|
        #rawstory = Rawstory.find(story)
        # @user_stories += rawstory.to_a if rawstory.created_at > Time.now.yesterday 
        story = Rawstory.find(story)
        @user_stories += story.to_a if story.created_at > date
      end
     end


     @user_stories = @user_stories.sort_by {|u| - u.id }  
     haufens = @user_stories.first(2)
    else
      haufens = []
                                              
    end
  end
    
  def fetch_my_searchterms s
    if logged_in?
      @search = Ultrasphinx::Search.new(:query => s, 
                                        :weights => { 'title' => 2.0 })

      @rawstories = @search.results
      
      if @language == 2
      @rawstories = @rawstories.find_all{|v| v.language == 2 }
      else 
      @rawstories = @rawstories.find_all{|v| v.language == 1 }
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
      
      haufens = @rawstories.first(2)
  
    else
      haufens = []                                              
    end
  
  end
  
end
