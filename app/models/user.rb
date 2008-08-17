class User < ActiveRecord::Base
  has_many :subscriptions
  has_many :authors,
    :through => :subscriptions,
    :source => :author
    
end
