class Author < ActiveRecord::Base
  has_many :rawstories
  has_many :subscriptions
  is_indexed :fields => [{:field => :name}],
             :delta => true
end
