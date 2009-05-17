require 'digest/sha1'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  has_many :subscriptions
  has_many :authors,
    :through => :subscriptions,
    :source => :author
  
  attr_accessor :password

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

  # find the user in the database, first by the facebook user id and if that fails through the email hash
  def self.find_by_fb_user(fb_user)
    User.find_by_fb_user_id(fb_user.uid) || User.find_by_email_hash(fb_user.email_hashes)
  end

  
  # Take the data returned from facebook and create a new user from it.
  # We don't get the email from Facebook and because a facebooker can only login through Connect we just generate a unique login name for them.
  # If you were using username to display to people you might want to get them to select one after registering through Facebook Connect
  def self.create_from_fb_connect(fb_user)
    t_login =  Array.new(12) { (rand(122-97) + 97).chr }.join
    new_facebooker = User.new(:name => fb_user.name, :login => "#{t_login}_#{fb_user.uid}", :password => "#{t_login}", :password_confirmation => "#{t_login}", :email => fb_user.proxied_email)
    new_facebooker.fb_user_id = fb_user.uid.to_i
    # We need to save without validations
    new_facebooker.save(false)
    new_facebooker.register_user_to_fb
  end
 
  # We are going to connect this user object with a facebook id. But only ever one account.
  def link_fb_connect(fb_user_id)
    unless fb_user_id.nil?
      # check for existing account
      existing_fb_user = User.find_by_fb_user_id(fb_user_id)
      # unlink the existing account
      unless existing_fb_user.nil?
        existing_fb_user.fb_user_id = nil
        existing_fb_user.save(false)
      end
      # link the new one
      self.fb_user_id = fb_user_id
      save(false)
    end
  end
  
  #The Facebook registers user method is going to send the users email hash and our account id to Facebook
  #We need this so Facebook can find friends on our local application even if they have not connect through connect
  #We hen use the email hash in the database to later identify a user from Facebook with a local user
  def register_user_to_fb
    users = {:email => email, :account_id => id}
    Facebooker::User.register([users])
    self.email_hash = Facebooker::User.hash_email(email)
    save(false)
  end
  
  def facebook_user?
    return !fb_user_id.nil? && fb_user_id > 0
  end

  
  after_create :register_user_to_fb
  def fb_user(fb_session, f_user=nil)
    @fb_user = f_user if !f_user.nil?
    return @fb_user   if defined?(@fb_user)
    fb_session ||= Facebooker::Session.create 
    @fb_user = self.fb_user_id == 0 ? nil : (Facebooker::User.new(self.fb_user_id, fb_session) rescue nil )
    @fb_user
  end
  
  def jurnalo_friends(fb_session)
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
