class GroupsController < ApplicationController
  
  #before_filter :determine_date
 
      
  def index   
    #unless read_fragment({:f => iphone_user_agent?, :part => 'bottom', :action => 'index', :l => @l, :page => params[:page] || 1}) 
    unless read_fragment({:f => iphone_user_agent?, :action => 'index', :i => @i, :l => @l, :page => params[:page] || 1})   
    @haufens = fetch_groups nil, nil   
    #end
    
    #unless read_fragment({:f => iphone_user_agent?, :part => 'bottom', :action => 'index', :l => @l, :page => params[:page] || 1}) 
    @top_opinions_haufens = fetch_opinions 1
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
    unless read_fragment({:f => iphone_user_agent?, :action => 'politics', :l => @l,:i => @i, :page => params[:page] || 1})   
    @haufens = fetch_groups 2, 0      
  end
    render :action => 'index'
  end
  
  def culture
    unless read_fragment({:f => iphone_user_agent?, :action => 'culture', :l => @l,:i => @i, :page => params[:page] || 1}) 
    @haufens = fetch_groups 3, 0
    end      
    render :action => 'index'
  end
  
  def science
    unless read_fragment({:f => iphone_user_agent?, :action => 'science', :l => @l,:i => @i, :page => params[:page] || 1}) 
    @haufens = fetch_groups 4, 0  
    end    
    render :action => 'index'
    
  end
  
  def business
    unless read_fragment({:f => iphone_user_agent?, :action => 'business', :l => @l,:i => @i, :page => params[:page] || 1})  
    @haufens = fetch_groups 5, 0
    end    
    render :action => 'index'
    
  end

  def sport
    unless read_fragment({:f => iphone_user_agent?, :action => 'sport', :l => @l,:i => @i, :page => params[:page] || 1})  
    @haufens = fetch_groups 6, 0
    end   
    render :action => 'index'
    
  end
  
  def mixed
    unless read_fragment({:f => iphone_user_agent?, :action => 'mixed', :l => @l,:i => @i, :page => params[:page] || 1}) 
    @haufens = fetch_groups 7, 0  
    end    
    render :action => 'index'
    
  end
  
  def humor
    unless read_fragment({:f => iphone_user_agent?, :action => 'humor', :l => @l,:i => @i, :page => params[:page] || 1})  
    @haufens = fetch_groups 8, 0
    end     
    render :action => 'index'
  end
  
  def technology
    unless read_fragment({:f => iphone_user_agent?, :action => 'technology', :l => @l,:i => @i, :page => params[:page] || 1}) 
    @haufens = fetch_groups 9, 0 
    end     
    render :action => 'index'
  end

  def opinions
    unless read_fragment({:f => iphone_user_agent?, :action => 'opinions', :l => @l, :i => @i, :page => params[:page] || 1}) 
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
        
        haufens = haufens.first(5) if conditions == nil
        haufens -= @haufens if home == 1 && @haufens != nil
        haufens = haufens.first(2) if home == 1
        #haufens = haufens.first(36)
       
        haufens = haufens.paginate :page => params[:page],
                                     :per_page => 5
        
                                   
      end
      
      def fetch_opinions(home)
        
        list = Olist.find(:last) 
        @stories =[]
       
      if @i==1

          if list.all
              story_array = list.all.split(/\ /) 
              story_array.each do |story|
                  @stories += Rawstory.find(story).to_a
              end
          end
  
       
      else
       
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
        
      end
        
        @stories = @stories.first(20)
        @stories = @stories.first(2) if home == 1
        haufens = @stories.paginate :page => params[:page],
                                     :per_page => 5
                                     
    end
    
    def fetch_my_authors
    if logged_in?  
     @user_stories =[]
     unless @current_user.stories.blank?
       story_ids     = @current_user.stories.split(' ')*","
       @user_stories = Rawstory.find(:all,
                                     :conditions => ["id IN ( #{story_ids} ) and created_at > ?", Time.now.yesterday],
                                     :order      => "id DESC",
                                     :limit      => 2)
     
     end

     haufens = @user_stories
    else
      haufens = []
                                              
    end
  end
    
  def fetch_my_searchterms s
    if logged_in?
       search_hash           = {:query => s, 
                                 :class_names => 'Rawstory', 
                                 :sort_mode   => 'descending',
                                 :sort_by     => 'created_at',
                                 :page        => 1,
                                 :per_page    => 100,
                                 :weights     => { 'title' => 2.0 }}
        search_hash[:filters] = {'language' => (@language == 2 ? 2 : 1)} unless @i == 1
        @search               = Ultrasphinx::Search.new(search_hash)
        @rawstories           = @search.results
        @matches              = @search.response[:matches]

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
      date = Time.now.yesterday
      @rawstories = @rawstories.find_all {|u| u.created_at > date }  
      @rawstories = @rawstories.sort_by {|u| - u.blub }  
      
      haufens = @rawstories.first(2)
  
    else
      haufens = []                                              
    end
  
  end
  
end
