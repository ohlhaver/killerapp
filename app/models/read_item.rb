class ReadItem < ActiveRecord::Base
  belongs_to :rawstory
  belongs_to :user
end
