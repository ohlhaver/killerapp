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

  def ranked_list
    subscriptions = Subscription.find(:all,
                                      :select => 'subscriptions.author_id, count(*) as popularity',
                                      :group  => 'subscriptions.author_id',
                                      :order  => 'popularity DESC',
                                      :include => [:author],
                                      :limit  => 25)
    authors_id_ar = []
    subscriptions.each{|s| authors_id_ar << s.author_id if s.popularity.to_i > 0}
    author_ids    = authors_id_ar.uniq*","
    @authors      = []
    unless author_ids.blank?
      @authors    = Author.find(:all, :conditions => "id IN ( #{author_ids} )")
    end
  end

end
