class Author < ActiveRecord::Base
has_many :rawstories
has_many :subscriptions
end
