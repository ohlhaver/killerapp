class Group < ActiveRecord::Base  
  belongs_to :gsession
  has_many :rawstories
end
