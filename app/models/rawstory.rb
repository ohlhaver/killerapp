class Rawstory < ActiveRecord::Base
  
  attr_accessor :age, :weight, :blub, :position, :score, :related
  
  belongs_to :group
  belongs_to :author
  belongs_to :feedpage
  belongs_to :source
  belongs_to :haufen
  has_one    :rawstory_detail
  is_indexed :fields =>[
  {:field => :title},
  {:field => :body},
  {:field => :opinion},
  {:field => :author_id},
  {:field => :language},
  {:field => :created_at}],
      :delta => true
  def subsciption_type
    self.feedpage.subscription_type
  end
end
