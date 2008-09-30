class AuthorsController < ApplicationController
  




  def show
    unless read_fragment({:id => params[:id], :page => params[:page] || 1}) 
        require 'will_paginate'
        @author = Author.find(params[:id])
        @rawstories_published = @author.rawstories.find(:all, :order => 'rawstories.id DESC')
        @rawstories_published = @rawstories_published.paginate :page => params[:page],
                                            :per_page => 8
    end
  end


end
