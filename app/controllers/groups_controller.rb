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
        
        haufens = haufens.first(3) if conditions == nil
        haufens -= @haufens if home == 1 && @haufens != nil
        haufens = haufens.first(2) if home == 1
        #haufens = haufens.first(36)
       
        haufens = haufens.paginate :page => params[:page],
                                     :per_page => 5
        
                                   
      end
      
      def fetch_opinions(home)
        
        list = Olist.find(:last) 
        @stories =[]
        story_id_ar = []
        if @i ==1
          story_id_ar = list.all.split(' ')
        elsif @language == 2
          story_id_ar = list.de.split(' ')
        else
          story_id_ar = list.en.split(' ')
        end
        story_id_ar = (home == 1) ? story_id_ar.first(2) : story_id_ar.first(20)
        story_ids = story_id_ar*","
        unless story_ids.blank?
          stories = Rawstory.find(:all,
                                  :conditions => "id IN ( #{story_ids} )")
          stories_h = stories.group_by{|s| s.id}
          story_id_ar.each{|id| @stories << stories_h[id.to_i].to_a.first if stories_h[id.to_i].to_a.first}
        end
        
        haufens = @stories.paginate :page => params[:page],
                                     :per_page => 5
                                     
     end
    
    def fetch_my_authors
    if logged_in?  
     @user_stories =[]
     unless @current_user.stories.blank?
       story_ids     = @current_user.stories.split(' ')*","
       @user_stories = Rawstory.find(:all,
                                   :conditions => ["rawstories.id IN ( #{story_ids} ) and rawstories.created_at > :yesterday and rawstory_details.is_duplicate = :false", {:yesterday => Time.now.yesterday, :false => false}],
                                   :order      => "rawstories.id DESC",
                                   :joins      => 'inner join rawstory_details on rawstory_details.rawstory_id = rawstories.id',
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
       search_hash[:filters]                 = {}
       search_hash[:filters][:language]      =  (@i==1 ? [1,2] : (@language == 2 ? 2 : 1))
       search_hash[:filters][:is_duplicate]  = 0

       @search               = Ultrasphinx::Search.new(search_hash)
       @rawstories           = @search.results
       @matches              = @search.response[:matches]

        counter = 0
        story_ids = @rawstories.collect{|s| s.id}.uniq*","
        unless story_ids.blank?
          qualities = RawstoryDetail.find(:all,
                                          :conditions => "rawstory_id IN ( #{story_ids} )",
                                          :select     => "rawstory_id, quality")
          qualities_hashed = qualities.group_by{|q| q.rawstory_id}
        end
        @rawstories.each do |story|
          weight = (@matches[counter])[:weight]  
          age = ((Time.new - story.created_at)/3600).to_i 
          age = 1 if age < 1
          age = (100*(1/(age**(0.33)))).to_i 

          quality_value = qualities_hashed[story.id].first.quality rescue nil
          quality_value ||= 1
          blub =  age*weight*quality_value


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
