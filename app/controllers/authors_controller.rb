class AuthorsController < ApplicationController
  




  def show
    unless read_fragment({:l => @l, :id => params[:id], :page => params[:page] || 1}) 
        
        @author = Author.find(params[:id])
        @rawstories_published = Ultrasphinx::Search.new(:query       => '',
                                                        :class_names => 'Rawstory', 
                                                        :sort_mode   => 'descending',
                                                        :sort_by     => 'created_at',
                                                        :filters     => {'author_id' => @author.id},
                                                        :page        => (params[:page] || 1).to_i,
                                                        :per_page    => 5)
        @rawstories_published.run

        #@rawstories_published = @author.rawstories.find(:all, :order => 'rawstories.id DESC')
        #@rawstories_published = @rawstories_published.paginate :page => params[:page],
        #                                    :per_page => 5
    end
  end


end
