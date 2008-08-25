class ClustersController < ApplicationController
before_filter :login_required
    def index
              
      cluster_session = (Cluster.find(:last, :conditions => 'c_session').c_session) 
      @clusters = Cluster.find(:all)
      @clusters = @clusters.find_all{|z| z.c_session == cluster_session} 
      @clusters = @clusters.sort_by {|u| - u.weight } 
      @clusters = @clusters.first(8)
      

    end
    
    def show
       @cluster = Cluster.find(params[:id])
       @cluster_stories = @cluster.rawstories.find(:all, :order => 'rawstories.id DESC')
       @cluster_stories = @cluster_stories.paginate :page => params[:page],
                                             :per_page => 8
    end


end
  

      

