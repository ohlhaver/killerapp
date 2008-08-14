class RawstoriesController < ApplicationController
  

  
  def search
    require 'will_paginate'

    @search = Ultrasphinx::Search.new(:query => params[:q], 
                                      :weights => { 'title' => 2.0 })
                                      
    #@search.run
    @rawstories = @search.results
    
    @matches = @search.response[:matches]
    
    counter = 0
    @rawstories.each do |story|
    weight = (@matches[counter])[:weight]  
    age = ((Time.new - story.created_at)/3600).to_i 
    age = ((24-(age))*100/24).to_i 
      
    blub = age*weight/100
    
    
    story.age = age   
    story.weight = weight
    story.blub = blub    
    counter = counter + 1
    end                                            
  
@rawstories = @rawstories.sort_by {|u| - u.blub }
  
    @rawstories = @rawstories.paginate  :page => params[:page],
                                        :per_page => 8
  
  
  end
 
  
end
