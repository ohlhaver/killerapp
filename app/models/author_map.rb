class AuthorMap < ActiveRecord::Base
  validates_presence_of :author_id , :unique_author_id
  belongs_to :author
  belongs_to :unique_author
end
