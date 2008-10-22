class AuthorsController < ApplicationController
  




  def show
    unless read_fragment({:l => @l, :id => params[:id], :page => params[:page] || 1}) 
        
        @author = Author.find(params[:id])
        @rawstories_published = @author.rawstories.find(:all, :order => 'rawstories.id DESC')
        @rawstories_published = @rawstories_published.paginate :page => params[:page],
                                            :per_page => 12
    end
  end


end
