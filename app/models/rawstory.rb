class Rawstory < ActiveRecord::Base
  
  belongs_to :author
  belongs_to :source

  is_indexed :fields =>[
  {:field => :title},
  {:field => :body},
  {:field => :opinion},
  {:field => :created_at}]
  
end
