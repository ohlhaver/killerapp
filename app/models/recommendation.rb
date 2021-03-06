class Recommendation < ActiveRecord::Base
  belongs_to :user
  belongs_to :recommender,
             :class_name => 'User',
             :foreign_key => 'recommender_id'
  belongs_to :resource, :polymorphic => true

  def self.from_valid_users(recommendations, users)
    user_ids = users.collect{|u| u.id}
    rs = []
    recommendations.each do |r|
      rs << r if user_ids.include?(r.recommender_id)
    end
    return rs
  end

  def self.mark_as_inactive(rec_array)
    return rec_array if rec_array.blank?
    ids = []
    rec_array.each{|r| ids << r.id if r.active}
    ids = ids.uniq*","
    return rec_array  if ids.blank?
    self.update_all(["active = ?", false], ["id IN ( #{ids} )"])
    rec_array.each{|r| r.active = false}
    return rec_array 
  end
  def mark_as_inactive
   Recommendation.mark_as_inactive([self])
  end
  def self.create_article_recommendation(article_id, recommender_id, user_id)
    r = Recommendation.find(:all, 
                            :conditions => ["recommender_id = :recommender_id and user_id = :user_id and resource_id = :article_id and resource_type = 'Rawstory'",  {:recommender_id => recommender_id.to_i,
                                            :user_id        => user_id.to_i,
                                            :article_id     => article_id.to_i}])
    return unless r.blank?
    Recommendation.create!(:recommender_id => recommender_id,
                           :user_id        => user_id,
                           :resource_id    => article_id,
                           :resource_type  => "Rawstory")

  end

  def self.create_author_recommendation(author_id, recommender_id, user_id)
    r = Recommendation.find(:all, 
                            :conditions => ["recommender_id = :recommender_id and user_id = :user_id and resource_id = :author_id and resource_type = 'Rawstory'",  {:recommender_id => recommender_id.to_i,
                                            :user_id        => user_id.to_i,
                                            :author_id     => author_id.to_i}])
    return unless r.blank?
    Recommendation.create!(:recommender_id => recommender_id,
                           :user_id        => user_id,
                           :resource_id    => author_id,
                           :resource_type  => "Author")

  end

  def article?
    case resource_type.strip
    when "Rawstory"
      true
    else
      false
    end
  end
  def author?
    case resource_type.strip
    when "Author"
      true
    else
      false
    end
  end
  def article
    article? ? resource : nil
  end
  def author
    author? ? resource : nil
  end

  def after_create
    ProfileAction.create_recommended_action(self)
    fb_session = Facebooker::Session.create
    # send email
    e = UserMailer.create_recommended_email(self) 
    if not user.jurnalo_user and user.facebook_user?
      fb_session.send_email([self.user.fb_user_id],e.subject, e.body)
    else
      UserMailer.deliver_recommended_email(self) 
    end
    # send facebook notification
    fb_session.send_notification([self.user.fb_user_id],"<a href=\"http://#{SITE_URL}/recommendations/view?l=#{self.user.language == 2 ? 'd' : 'e'}\">#{e.subject}</a>")
  end
end
