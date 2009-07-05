class Author < ActiveRecord::Base
  has_many :rawstories
  has_many :subscriptions
  has_one  :author_map
  is_indexed :fields => [{:field => :name}],
             :delta => true

  def author_ids_in_group(include_self=true)
    group_ids = include_self ? [self.id] : []
    return group_ids if self.approval_status != JConst::AuthorStatus::APPROVED
   
    unique_author_id = self.author_map.unique_author_id
    group_ids = AuthorMap.find(:all, 
                                :conditions => ["unique_author_id = :unique_author_id and status = :approved",
                                                {:unique_author_id => unique_author_id, 
                                                 :approved => JConst::AuthorMapStatus::APPROVED}],
                                :select => 'author_id').collect{|a| a.author_id}
    return group_ids
  end
  
end
