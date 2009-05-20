class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :author
  def after_create
    ProfileAction.create_added_favorite_author_action(self)                            
  end

  def after_destroy
    ProfileAction.create_removed_favorite_author_action(self)                            
  end

end
