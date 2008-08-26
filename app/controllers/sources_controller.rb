class SourcesController < ApplicationController



def show
  require 'will_paginate'
  @source = Source.find(params[:id])
  @rawstories_published = @source.rawstories.find(:all, :order => 'rawstories.id DESC', :limit => '100')
  @rawstories_published = @rawstories_published.paginate :page => params[:page],
                                        :per_page => 8
end



end