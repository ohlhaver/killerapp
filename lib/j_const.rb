class JConst
  class SubscriptionType
    FREE_LOGIN_NOT_NEEDED  = 0
    FREE_LOGIN_NEEDED      = 1
    PAID_LOGIN_NEEDED      = 2
    class << self
      def login_required?(s_t)
        case s_t
        when FREE_LOGIN_NEEDED, PAID_LOGIN_NEEDED
          true
        else
          false
        end
      end
    end
  end
  class Quality
    LOW     = 1
    MEDIUM  = 2
    HIGH    = 3
  end
end
