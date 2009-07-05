class Author < ActiveRecord::Base
  has_many :rawstories
  has_many :subscriptions
  has_one  :author_map
  is_indexed :fields => [{:field => :name}],
             :delta => true
  def approved_map
    return @approved_map if defined?(@approved_map)
    @approved_map = AuthorMap.find(:first, :conditions => [" author_id = :author_id and status = :approved",{:author_id => self.id, :approved => JConst::AuthorMapStatus::APPROVED}])
    return @approved_map
  end
  def author_ids_in_group(include_self=true)
    group_ids = include_self ? [self.id] : []
    return group_ids unless self.approved?
   
    unique_author_id = self.approved_map.unique_author_id
    group_ids = AuthorMap.find(:all, 
                                :conditions => ["unique_author_id = :unique_author_id and status = :approved",
                                                {:unique_author_id => unique_author_id, 
                                                 :approved => JConst::AuthorMapStatus::APPROVED}],
                                :select => 'author_id').collect{|a| a.author_id}
    return group_ids
  end
  
  def group_primary_author_id
    return self.id unless self.approved?
    return self.approved_map.unique_author_id
  end
  def approved?
    self.approval_status == JConst::AuthorStatus::APPROVED
  end
end
