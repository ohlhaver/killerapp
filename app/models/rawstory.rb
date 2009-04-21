class Rawstory < ActiveRecord::Base
  
  attr_accessor :age, :weight, :blub, :position, :score, :related
  
  belongs_to :group
  
  belongs_to :author
  belongs_to :source
  belongs_to :haufen
  is_indexed :fields =>[
  {:field => :title},
  {:field => :body},
  {:field => :opinion},
  {:field => :author_id},
  {:field => :created_at}],
      :delta => true
  
  
end
