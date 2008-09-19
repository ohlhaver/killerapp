class GroupsController < ApplicationController
  
  #before_filter :login_required
     
      
      def index
        fetch_groups nil
      end
      
      def politics
        fetch_groups 2      
        render :action => 'index'
      end
      
      def culture
        fetch_groups 3      
        render :action => 'index'
      end
      
      def science
        fetch_groups 4      
        render :action => 'index'
      end
      
      def business
        fetch_groups 5      
        render :action => 'index'
      end

      def sport
        fetch_groups 6   
        render :action => 'index'
      end
      
      def mixed
        fetch_groups 7      
        render :action => 'index'
      end
      
      def humor
        fetch_groups 8      
        render :action => 'index'
      end
      
      def technology
        fetch_groups 9      
        render :action => 'index'
      end





      
     protected
     def fetch_groups(conditions)
        @haufens = Hsession.find(:last).haufens  
        (@haufens = @haufens.find_all {|u| u.topic == conditions }) if conditions != nil
        @haufens = @haufens.sort_by {|u| - u.weight }  
        
        @haufens = @haufens.first(8) #if conditions == nil
        
        
      end

  
end
