class RawstoriesController < ApplicationController
  
before_filter :login_required
  
  def index

  end
  
  
  def search
    require 'will_paginate'
    @current_user.query = params[:q] unless params[:q] == nil
    @current_user.save
    @search = Ultrasphinx::Search.new(:query => @current_user.query, 
                                      :weights => { 'title' => 2.0 })
                                      
    #@search.run
    @rawstories = @search.results
    
    @matches = @search.response[:matches]
    
    counter = 0
    @rawstories.each do |story|
    weight = (@matches[counter])[:weight]  
    age = ((Time.new - story.created_at)/3600).to_i 
    age = 1 if age < 1
    age = (100*(1/(age**(0.33)))).to_i 
      
    blub = age*weight/100
    
    
    story.age = age   
    story.weight = weight
    story.blub = blub    
    counter = counter + 1
    end                                            
  
    @rawstories = @rawstories.sort_by {|u| - u.blub }  
    
    
    
    
    (@rawstories = @rawstories.find_all{|v| v.opinion == 1 } ) if @current_user.filter == 1 
    
    @rawstories = @rawstories.paginate  :page => params[:page],
                                        :per_page => 8
                                        
  
  end
 
 def filter_by_opinions
   @current_user.filter = 1
   @current_user.save
   redirect_to :action => 'search'
 end
   
 def show_all
   @current_user.filter = 0
   @current_user.save
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







   
 
 
  
end
