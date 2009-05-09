class DuplicateGroup < ActiveRecord::Base
  has_many :rawstory_details
  has_many :rawstories,
           :through => :rawstory_details,
           :source  => :rawstory
end
