class Feedpage < ActiveRecord::Base

validates_presence_of :url
has_many :rawstories
belongs_to :source

  class SubscrptionType
    FREE_AND_AUTHENTICATION_NOT_NEEDED = 0
    FREE_AND_AUTHENTICATION_NEEDED     = 1
    PAID_AND_AUTHENTICATION_NEEDED     = 2
  end
end
