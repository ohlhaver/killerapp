class UniqueAuthor < ActiveRecord::Base
  validates_presence_of :name
  has_many :author_map
  is_indexed :fields =>[{:field => :name},
                        {:field => :opinionated},
                        {:field => :created_at}],
             :delta => true

end
