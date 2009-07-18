require 'digest/sha1'
class User < ActiveRecord::Base
  has_one   :home_page_conf
  # Virtual attribute for the unencrypted password
  has_many :notifications, 
           :class_name => 'ProfileNotification',
           :foreign_key => 'user_id',
           :order => "id DESC"
  has_many :active_notifications,
           :class_name => 'ProfileNotification',
           :foreign_key => 'user_id',
           :conditions => ["active = ?", true],
           :order => "id DESC"

  has_many :new_friend_notifications,
           :class_name => 'ProfileNotification',
           :foreign_key => 'user_id',
           :conditions => ["notification_type = ? ", ProfileNotification::Type::GOT_NEW_FRIEND],
           :order => "id DESC"

  has_many :active_new_friend_notifications,
           :class_name => 'ProfileNotification',
           :foreign_key => 'user_id',
           :conditions => ["active = ? and notification_type = ? ", true, ProfileNotification::Type::GOT_NEW_FRIEND],
           :order => "id DESC"

  has_many :recommendations, 
           :order => "id DESC"
  has_many :author_recommendations,
           :class_name => 'Recommendation',
           :foreign_key => 'user_id',
           :conditions => "resource_type = 'Author'",
           :order => "id DESC"

  has_many :article_recommendations,
           :class_name => 'Recommendation',
           :foreign_key => 'user_id',
           :conditions => "resource_type = 'Rawstory'",
           :order => "id DESC"

  has_many :active_recommendations,
           :class_name => 'Recommendation',
           :foreign_key => 'user_id',
           :conditions => ["active = ?", true],
           :order => "id DESC"
           
  has_many :active_author_recommendations,
           :class_name => 'Recommendation',
           :foreign_key => 'user_id',
           :conditions => ["resource_type = 'Author' and active = ?", true],
           :order => "id DESC"

  has_many :active_article_recommendations,
           :class_name => 'Recommendation',
           :foreign_key => 'user_id',
           :conditions => ["resource_type = 'Rawstory' and active = ?", true],
           :order => "id DESC"

  has_many :provided_recommendations,
             :class_name => 'Recommendation',
             :foreign_key => 'recommender_id',
             :order => "id DESC"

  has_many :subscriptions
  has_many :authors,
    :through => :subscriptions,
    :source => :author
  
  attr_accessor :password

  has_many :profile_actions, :order => "id DESC"

  class Alert
    OFF       = 0
    IMMEDIATE = 1
    DAILY     = 2
    WEEKLY    = 3
  end
  def alerts_on?
    alert_type != Alert::OFF
  end
  def alerts_off?
    alert_type == Alert::OFF
  end

  def all_profile_actions
    ProfileAction.find(:all,
                       :conditions => ["user_id = :current_user_id or receiver_user_id = :current_user_id",{:current_user_id => self.id }],
                       :order => "id DESC")
  end

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  before_save :encrypt_password
  before_create :make_activation_code 
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation
  #########################################
  # Facebook integratioin methods : Start
  ########################################
  def grant_email_permission
    self.fb_email_permission_granted = true
    save!
  end
  def remove_infinite_session_key
    #Facebooker::User.unregister([email_hash])
    self.fb_email_permission_granted = false
    self.fb_session_key = ''
    save!
  end

  def add_infinite_session_key(inf_session_key)
    old_val = self.fb_offline_access_permission_granted
    self.fb_session_key = inf_session_key
    self.fb_offline_access_permission_granted = true
    save!
  end
  # find the user in the database, first by the facebook user id and if that fails through the email hash
  def self.find_by_fb_user(fb_user)
    user = User.find_by_fb_user_id(fb_user.id) || User.find_by_email_hash(fb_user.email_hashes)
    user
  end

  
  # Take the data returned from facebook and create a new user from it.
  # We don't get the email from Facebook and because a facebooker can only login through Connect we just generate a unique login name for them.
  # If you were using username to display to people you might want to get them to select one after registering through Facebook Connect
  def self.create_from_fb_connect(fb_user)
    t_login =  Array.new(12) { (rand(122-97) + 97).chr }.join
    new_facebooker = User.new(:login                 => "#{t_login}_#{fb_user.uid}", 
                              :password              => "#{t_login}", 
                              :password_confirmation => "#{t_login}",
                              :email                 => fb_user.proxied_email)
    new_facebooker.name = fb_user.name
    new_facebooker.fb_user_id = fb_user.uid
    new_facebooker.jurnalo_user = false
    new_facebooker.save!
    new_facebooker.activate

    new_facebooker
  end
 
  # We are going to connect this user object with a facebook id. But only ever one account.
  def link_fb_connect(fb_user_id)
    unless fb_user_id.nil?
      # check for existing account
      existing_fb_user = User.find_by_fb_user_id(fb_user_id)
      # unlink the existing account
      unless existing_fb_user.nil?
        existing_fb_user.fb_user_id = nil
        existing_fb_user.save!
      end
      # link the new one
      self.fb_user_id = fb_user_id
      save!
    end
  end
  
  #The Facebook registers user method is going to send the users email hash and our account id to Facebook
  #We need this so Facebook can find friends on our local application even if they have not connect through connect
  #We hen use the email hash in the database to later identify a user from Facebook with a local user
  def register_user_to_fb
    users = {:email => email, :account_id => id}
    Facebooker::User.register([users])
    self.email_hash = Facebooker::User.hash_email(email)
    save!
    # create notifications for friends
    self.jurnalo_friends.each do |u|
      ProfileNotification.create_got_new_friend_notification(u.id, self.id)
    end
    # create action for the user
    ProfileAction.create_joined_jurnalo_action(self.id)
  end
  

  def facebook_user?
    return !fb_user_id.nil? && fb_user_id > 0
  end
  def fb_user=(f_user)
    @fb_user=f_user
  end
  def fb_user(force_cache_write=false)
    return nil           if self.fb_user_id == 0 
    return @fb_user      if defined?(@fb_user)
    if fb_offline_access_permission_granted
      @fb_user = Rails.cache.read("user_#{self.id}_fb_user_#{fb_user_id}")
      if @fb_user.nil?
        fb_s = Facebooker::Session.create 
        fb_s.secure_with!(fb_session_key, fb_user_id)
        @fb_user =  Facebooker::User.new(fb_user_id, fb_s)
        name = @fb_user.name
        force_cache_write = true
      end
      Rails.cache.write("user_#{self.id}_fb_user_#{fb_user_id}", @fb_user) if force_cache_write == true
    else 
      @fb_user = nil
    end
     return @fb_user
  end

  def is_a_friend?(user_id_or_user)
    user = (user_id_or_user.class == User)? user_id_or_user : User.find_by_id(user_id_or_user)
    self.fb_user.friends_with?(user.fb_user_id)
  end
  
  def jurnalo_friends
    return @friends if defined?(@friends)
    fb_u            = fb_user
    if fb_u.blank?
      @friends = []
      return @friends
    end
    jurnalo_friends = fb_u.friends_with_this_app rescue []
    if jurnalo_friends.blank?
      @friends = []
      return @friends
    end
    jurnalo_users   = User.find(:all, :conditions => "fb_user_id IN ( #{jurnalo_friends.collect{|f| f.id}*','} )")
    #jurnalo_users_h = jurnalo_users.group_by{|u| u.fb_user_id}
    #jurnalo_friends.each do | fbu|
    #  u = jurnalo_users_h[fbu.uid].first
    #  u.fb_user=fbu
    #end
    jurnalo_users.reject!{|u| 
      !(u.fb_offline_access_permission_granted and (u.fb_email_permission_granted or u.jurnalo_user)  and u.fb_user)
    }
    @friends = jurnalo_users
  end
  def jurnalo_friends_profile_actions(limit=nil, last_24_hours = false)
    friends = self.jurnalo_friends
    return [] if friends.blank?
    if last_24_hours == false
    ProfileAction.find(:all,
                       :conditions => "user_id IN ( #{friends.collect{|f| f.id}*','} )", 
                       :order => "created_at DESC",
                       :limit => limit)
    else
    ProfileAction.find(:all,
                       :conditions => ["user_id IN ( #{friends.collect{|f| f.id}*','} ) and created_at >= :one_day_before",{ :one_day_before => (Time.now - 1.day)}],
                       :order => "created_at DESC",
                       :limit => limit)
    end

  end
  #########################################
  # Facebook integratioin methods : End
  ########################################

  # Activates the user in the database.
  def activate
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    return nil if login.blank? or password.blank?
    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  # Send email alert for stories from subscribed authors
  def send_alerts(stories=nil)
    if not stories.blank? and self.alerts_on?
      if not self.jurnalo_user and self.facebook_user?
        fb_session = Facebooker::Session.create
        e = UserMailer.create_change_alert(self,stories) 
        fb_session.send_email([self.fb_user_id], e.subject, e.body)
      else
        UserMailer.deliver_change_alert(self,stories) 
      end
    end
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
    def make_activation_code

      self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end
    
end
