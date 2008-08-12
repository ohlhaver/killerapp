class RawstoriesController < ApplicationController
  

  
  def search
    require 'will_paginate'

    @search = Ultrasphinx::Search.new(:query => params[:q], 
                                      :weights => { 'title' => 2.0 })
                                      
    @search.run
    @rawstories = @search.results
    @rawstories = @rawstories.paginate :page => params[:page],
                                        :per_page => 8
  end
 
  
end
