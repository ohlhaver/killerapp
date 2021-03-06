class AuthorsController < ApplicationController
  




  def show
    @author = Author.find(params[:id])
    unless read_fragment({:l => @l, :id => params[:id], :page => params[:page] || 1}) 
        author_ids_in_group = @author.author_ids_in_group
        @rawstories_published = Ultrasphinx::Search.new(:query       => '',
                                                        :class_names => 'Rawstory', 
                                                        :sort_mode   => 'descending',
                                                        :sort_by     => 'created_at',
                                                        :filters     => {:author_id => author_ids_in_group, :is_duplicate => 0},
                                                        :page        => (params[:page] || 1).to_i,
                                                        :per_page    => 10)
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

    subscriptions_hashed = subscriptions.group_by{|a| a.author_id}
    authors_id_ar = []
    subscriptions.each{|s| authors_id_ar << s.author_id if s.popularity.to_i >= 2}
    author_ids    = authors_id_ar.uniq*","
    @authors      = []
    unless author_ids.blank?
      @authors    = Author.find(:all, :conditions => "id IN ( #{author_ids} )").sort_by{|a| -(subscriptions_hashed[a.id].first.popularity.to_i rescue 1)}
    end
  end

end
