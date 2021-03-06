class GroupsController < ApplicationController
  
  #before_filter :determine_date
 
      
  def index   
    caching_hash = {:action => 'index', :f => iphone_user_agent?, :l => @l, :i => @i}
    if iphone_user_agent?
      caching_hash[:part] = 'top_stories'
      unless read_fragment(caching_hash)
        @haufens = fetch_groups nil, nil        
      end
      caching_hash[:part] = 'bottom'
      unless read_fragment(caching_hash)     
        @top_politics_haufens = fetch_groups 2, 1
        @top_business_haufens = fetch_groups 5, 1
        @top_culture_haufens = fetch_groups 3, 1
        @top_science_haufens = fetch_groups 4, 1
        @top_technology_haufens = fetch_groups 9, 1
        @top_sport_haufens = fetch_groups 6, 1
        @top_mixed_haufens = fetch_groups 7, 1
        @top_opinions_haufens = fetch_opinions 1
      end
    else
     caching_hash[:part]   = 'top_stories'
     @haufens              = fetch_groups nil, nil unless read_fragment(caching_hash) 

     caching_hash[:part]   = 'politics'
     @top_politics_haufens = fetch_groups 2, 1 if (not logged_in? or
                                                   @current_user.home_page_conf.maximized?('politics')) and
                                                   not read_fragment(caching_hash)
     caching_hash[:part]   = 'business'
     @top_business_haufens = fetch_groups 5, 1 if (not logged_in? or
                                                   @current_user.home_page_conf.maximized?('business')) and
                                                   not read_fragment(caching_hash)

     caching_hash[:part]  = 'culture'
     @top_culture_haufens = fetch_groups 3, 1  if (not logged_in? or
                                                   @current_user.home_page_conf.maximized?('culture')) and
                                                   not read_fragment(caching_hash)

     caching_hash[:part]  = 'science'
     @top_science_haufens = fetch_groups 4, 1  if (not logged_in? or
                                                   @current_user.home_page_conf.maximized?('science')) and
                                                   not read_fragment(caching_hash)

     caching_hash[:part]     = 'technology'
     @top_technology_haufens = fetch_groups 9, 1  if (not logged_in? or
                                                      @current_user.home_page_conf.maximized?('technology')) and
                                                      not read_fragment(caching_hash)

     caching_hash[:part] = 'sport'
     @top_sport_haufens  = fetch_groups 6, 1   if (not logged_in? or
                                                  @current_user.home_page_conf.maximized?('sport')) and
                                                  not read_fragment(caching_hash)

     caching_hash[:part] = 'mixed'
     @top_mixed_haufens = fetch_groups 7, 1    if (not logged_in? or
                                                  @current_user.home_page_conf.maximized?('mixed')) and
                                                  not read_fragment(caching_hash)

     caching_hash[:part] = 'opinions'
     @top_opinions_haufens = fetch_opinions 1  if (not logged_in? or
                                                  @current_user.home_page_conf.maximized?('mixed')) and
                                                  not read_fragment(caching_hash)

    end
    
    @top_my_searchterms= {}
    @top_my_authors = []
    if logged_in?
      @cache_key = CacheUtils.generate_key({:controller => params[:controller],
                                            :action      => params[:action],
                                            :user_id     => @current_user.id,
                                            :i           => @i,
                                            :l           => @l})
      cache_read = Rails.cache.read(@cache_key) || {}
      unless cache_read.blank?
        if @searchterms
          cache_read[:top_my_searchterms] ||= {}
          @searchterms.each do |s|
            @top_my_searchterms[s] = cache_read[:top_my_searchterms][s]
            if @top_my_searchterms[s].nil?
              @top_my_searchterms[s] = fetch_my_searchterms s
              cache_read[:top_my_searchterms][s] = @top_my_searchterms[s]
              Rails.cache.write(@cache_key, cache_read) unless cache_read.blank?
            end
          end
        end
        @top_my_authors = cache_read[:top_my_authors].to_a
      else
        if @searchterms
          @searchterms.each do |s|
            @top_my_searchterms[s] = fetch_my_searchterms s
          end
          cache_read[:top_my_searchterms]= @top_my_searchterms
        end
        @top_my_authors = fetch_my_authors 
        cache_read[:top_my_authors]= @top_my_authors
        Rails.cache.write(@cache_key, cache_read) unless cache_read.blank?
      end
    end 
    
    
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
        haufens = Hsession.find(:all, :order => "id DESC", :limit => 2).last.haufens
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
                                     :per_page => 10
        
                                   
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
        #story_id_ar = (home == 1) ? story_id_ar.first(2) : story_id_ar.first(20)
        limit = (home == 1) ? 2 : 20
        story_ids = story_id_ar*","
        unless story_ids.blank?
          @stories = Rawstory.find_by_sql("select rawstories.*, FIND_IN_SET(rawstories.id, '#{story_ids}') as ranking from rawstories, rawstory_details where rawstories.id = rawstory_details.rawstory_id and rawstories.id IN ( #{story_ids} ) and rawstory_details.is_duplicate = 0 order by ranking ASC limit #{limit}")
        end
        
        haufens = @stories.paginate :page => params[:page],
                                     :per_page => 5
      
     end
    
    def fetch_my_authors(user=@current_user)
    if user  
     @user_stories =[]
     unless user.stories.blank?
       story_ids     = user.stories.split(' ')*","
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
    return haufens
  end
    
  def fetch_my_searchterms(s, i=@i,language=@language,user=@current_user)
    if user
       search_hash           = {:query => s, 
                                :class_names => 'Rawstory', 
                                :sort_mode   => 'descending',
                                :sort_by     => 'created_at',
                                :page        => 1,
                                :per_page    => 100,
                                :weights     => { 'title' => 2.0 }}
       search_hash[:filters]                 = {}
       search_hash[:filters][:language]      =  (i==1 ? [1,2] : (language == 2 ? 2 : 1))
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
      haufens.each do |rs|
        s = rs.source 
        a = rs.author
      end
  
    else
      haufens = []                                              
    end
  
    return haufens
  end
  
end
