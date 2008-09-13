class Haufen < ActiveRecord::Base
  belongs_to :hsession
  has_many :rawstories
end
