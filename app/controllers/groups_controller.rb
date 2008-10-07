class GroupsController < ApplicationController
  
  before_filter :determine_german_date

      
  def index   
   unless read_fragment :action => 'index'    
    fetch_groups nil  
    end
  end
  
  def politics
    unless read_fragment :action => 'politics'  
    fetch_groups 2      
  end
    render :action => 'index'
  end
  
  def culture
    unless read_fragment :action => 'culture' 
    fetch_groups 3
    end      
    render :action => 'index'
  end
  
  def science
    unless read_fragment :action => 'science' 
    fetch_groups 4  
    end    
    render :action => 'index'
    
  end
  
  def business
    unless read_fragment :action => 'business' 
    fetch_groups 5  
    end    
    render :action => 'index'
    
  end

  def sport
    unless read_fragment :action => 'sport' 
    fetch_groups 6
    end   
    render :action => 'index'
    
  end
  
  def mixed
    unless read_fragment :action => 'mixed' 
    fetch_groups 7  
    end    
    render :action => 'index'
    
  end
  
  def humor
    unless read_fragment :action => 'humor' 
    fetch_groups 8 
    end     
    render :action => 'index'
  end
  
  def technology
    unless read_fragment :action => 'technology' 
    fetch_groups 9 
    end     
    render :action => 'index'
  end

  def opinions
    unless read_fragment :action => 'opinions' 
    fetch_opinions 
    end 
        
    render :action => 'index'
  end


      
     protected
     def fetch_groups(conditions)
        right_session = Hsession.find(:last).id - 1
        @haufens = Hsession.find(right_session).haufens  
        (@haufens = @haufens.find_all {|u| u.topic == conditions }) if conditions != nil
        if conditions == nil
            (@haufens = @haufens.find_all {|u| u.topic != 6 }) 
            (@haufens = @haufens.find_all {|u| u.topic != 7 })
        end
        
        @haufens = @haufens.sort_by {|u| - u.weight }  
        
        @haufens = @haufens.first(8) #if conditions == nil  
      end
      
      def fetch_opinions
        require 'will_paginate'
        
        @stories = Rawstory.find(:all, :conditions => ['created_at > :date', {:date => Time.now.yesterday}], :order => 'id DESC')       
        @stories = @stories.find_all{|v| v.opinion == 1 }
        @stories = @stories.find_all{|v| v.author.name != '' }
        @stories = @stories.sort_by {|u| - u.author.subscriptions.size}
        @haufens = @stories.first(8)
        #@haufens = @stories.paginate :page => params[:page],
        #                             :per_page => 8
                                     
    end
  
end
