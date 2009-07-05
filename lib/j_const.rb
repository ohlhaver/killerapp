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
  class AuthorStatus
    SUGGESTION_PENDING = 0 ## Suggestion Generation for this author has not yet been done
    APPROVAL_PENDING = 1   ## Suggestions have been generated for this author, but have not yet been approved
    APPROVED = 2           ## Suggestions have been generated and approved.
  end
  class AuthorMapStatus
    UNAPPROVED = 0    ## These suggestions are not yet approved manually.
    APPROVED   = 1    ## These suggestions have been approved manually. So they are Author groups.
  end
end
