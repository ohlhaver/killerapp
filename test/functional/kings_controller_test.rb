require File.dirname(__FILE__) + '/../test_helper'
require 'kings_controller'

# Re-raise errors caught by the controller.
class KingsController; def rescue_action(e) raise e end; end

class KingsControllerTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :kings

  def setup
    @controller = KingsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_allow_signup
    assert_difference 'King.count' do
      create_king
      assert_response :redirect
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference 'King.count' do
      create_king(:login => nil)
      assert assigns(:king).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'King.count' do
      create_king(:password => nil)
      assert assigns(:king).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'King.count' do
      create_king(:password_confirmation => nil)
      assert assigns(:king).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference 'King.count' do
      create_king(:email => nil)
      assert assigns(:king).errors.on(:email)
      assert_response :success
    end
  end
  

  
  def test_should_sign_up_user_with_activation_code
    create_king
    assigns(:king).reload
    assert_not_nil assigns(:king).activation_code
  end

  def test_should_activate_user
    assert_nil King.authenticate('aaron', 'test')
    get :activate, :activation_code => kings(:aaron).activation_code
    assert_redirected_to '/'
    assert_not_nil flash[:notice]
    assert_equal kings(:aaron), King.authenticate('aaron', 'test')
  end
  
  def test_should_not_activate_user_without_key
    get :activate
    assert_nil flash[:notice]
  rescue ActionController::RoutingError
    # in the event your routes deny this, we'll just bow out gracefully.
  end

  def test_should_not_activate_user_with_blank_key
    get :activate, :activation_code => ''
    assert_nil flash[:notice]
  rescue ActionController::RoutingError
    # well played, sir
  end

  protected
    def create_king(options = {})
      post :create, :king => { :login => 'quire', :email => 'quire@example.com',
        :password => 'quire', :password_confirmation => 'quire' }.merge(options)
    end
end
