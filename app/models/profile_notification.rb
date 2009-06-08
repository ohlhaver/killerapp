class ProfileNotification < ActiveRecord::Base
  belongs_to :entity, :polymorphic => true
  belongs_to :user
  class Type
    AUTHOR_RECOMMENDATION_RECEIVED  = 1
    ARTICLE_RECOMMENDATION_RECEIVED = 2
    GOT_NEW_FRIEND                  = 3
  end

  def self.from_valid_users(notifications, users)
    user_ids = users.collect{|u| u.id}
    ns = []
    notifications.each do |n|
      case n.notification_type
      when Type::GOT_NEW_FRIEND
        ns << n if user_ids.include?(n.entity_id)
      else
        ns << n  
      end
    end
    return ns
  end
  def friend?
    notification_type == Type::GOT_NEW_FRIEND
  end

  def friend
   if notification_type == Type::GOT_NEW_FRIEND
     entity
   else
     nil
   end
  end

  def self.mark_as_inactive(noti_array)
    return noti_array if noti_array.blank?
    ids = []
    noti_array.each{|r| ids << r.id if r.active}
    ids = ids.uniq*","
    return noti_array  if ids.blank?
    self.update_all(["active = ?", false], ["id IN ( #{ids} )"])
    noti_array.each{|r| r.active = false}
    return noti_array 
  end
  def mark_as_inactive
   ProfileNotification.mark_as_inactive([self])
  end


  def self.create_got_new_friend_notification(user_id, friend_user_id)
    self.create!(:user_id => user_id,
                 :notification_type => Type::GOT_NEW_FRIEND,
                 :entity_id         => friend_user_id,
                 :entity_type       => 'User')
  end
end
