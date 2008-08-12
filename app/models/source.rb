class Source < ActiveRecord::Base
  has_many :feedpages
  has_many :rawstories
end
