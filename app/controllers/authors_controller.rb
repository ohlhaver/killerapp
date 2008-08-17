class AuthorsController < ApplicationController
  




  def show
     @author = Author.find(params[:id])
     @rawstories_published = @author.rawstories.find(:all, :order => 'rawstories.id DESC')
     @rawstories_published = @rawstories_published.paginate :page => params[:page],
                                           :per_page => 8
  end


end
