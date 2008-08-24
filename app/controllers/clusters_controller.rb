class ClustersController < ApplicationController
before_filter :login_required
    def index
              
      cluster_session = Cluster.find(:last).c_session  
      @clusters = Cluster.find(:all)
      @clusters = @clusters.find_all{|z| z.c_session == cluster_session} 
      @clusters = @clusters.sort_by {|u| - u.weight } 
      @clusters = @clusters.first(8)
    end



end
  

      

