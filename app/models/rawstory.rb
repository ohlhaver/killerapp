class Rawstory < ActiveRecord::Base
  
  attr_accessor :age, :weight, :blub, :position, :score, :related
  
  belongs_to :cluster
  
  belongs_to :author
  belongs_to :source

  is_indexed :fields =>[
  {:field => :title},
  {:field => :body},
  {:field => :opinion},
  {:field => :created_at}],
      :delta => true
  
  
end
