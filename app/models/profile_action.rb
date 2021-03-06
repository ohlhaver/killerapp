class ProfileAction < ActiveRecord::Base
  belongs_to :entity, :polymorphic => true
  belongs_to :user
  belongs_to :receiver,
             :class_name => 'User',
             :foreign_key => 'receiver_user_id'
  class Type
    ADDED_FAVORITE_AUTHOR    = 1 
    REMOVED_FAVORITE_AUTHOR  = 2
    ADDED_SEARCH_TOPIC       = 3
    REMOVED_SEARCH_TOPIC     = 4
    RECOMMENDED_AUTHOR       = 5
    RECOMMENDED_ARTICLE      = 6
    GOT_NEW_FRIEND           = 7
    JOINED_JURNALO           = 8
    LIKED_ARTICLE            = 9 
    LIKED_AUTHOR             = 10
  end

  def description(language=1)
    case action_type
    when  Type::ADDED_FAVORITE_AUTHOR    
      language == 2 ?  "subscribed to author" : "subscribed to author"
    when  Type::REMOVED_FAVORITE_AUTHOR 
      language == 2 ?  "unsubscribed from author" : "unsubscribed from author"
    when  Type::ADDED_SEARCH_TOPIC        
      language == 2 ? "added the search topic" : "added the search topic"
    when  Type::REMOVED_SEARCH_TOPIC      
      language == 2 ? "removed the search topic" : "removed the search topic"
    when  Type::RECOMMENDED_AUTHOR        
      language == 2 ? "recommended author" : "recommended author"
    when  Type::RECOMMENDED_ARTICLE       
      language == 2 ? "recommended this article" : "recommended this article"
    when  Type::GOT_NEW_FRIEND            
      language == 2 ? "got new friend" : "got new friend"
    when  Type::JOINED_JURNALO            
      language == 2 ? "connected with Jurnalo" : "connected with Jurnalo"
    when  Type::LIKED_ARTICLE            
      language == 2 ? "likes this article" : "likes this article"
    when  Type::LIKED_AUTHOR            
      language == 2 ? "likes author" : "likes author"

    else
      ''
    end
  end

  def is_author_recommendation?
    action_type ==  Type::RECOMMENDED_AUTHOR
  end

  def is_article_recommendation?
    action_type ==  Type::RECOMMENDED_ARTICLE
  end

  def joined_jurnalo?
    Type::JOINED_JURNALO == self.action_type
  end
  def author
    case action_type
    when Type::ADDED_FAVORITE_AUTHOR, Type::REMOVED_FAVORITE_AUTHOR, Type::RECOMMENDED_AUTHOR
      entity
    else
      nil
    end
  end

  def article
    case action_type
    when Type::RECOMMENDED_ARTICLE
      entity
    else
      nil
    end
  end
  def search_topic
    case action_type
    when Type::ADDED_SEARCH_TOPIC, Type::REMOVED_SEARCH_TOPIC
      entity_content
    else
      nil
    end
  end
  def friend
    case action_type
    when Type::GOT_NEW_FRIEND
      entity
    else
      nil
    end
  end

  def self.create_added_search_topic_action(user_id, search_term)
    self.create!(:user_id        => user_id,
                 :action_type    => ProfileAction::Type::ADDED_SEARCH_TOPIC,
                 :entity_content => "#{search_term}")
  end
  def self.create_removed_search_topic_action(user_id, search_term)
    self.create!(:user_id        => user_id,
                 :action_type    => ProfileAction::Type::REMOVED_SEARCH_TOPIC,
                 :entity_content => "#{search_term}")

  end
  def self.create_added_favorite_author_action(subscription)
    self.create!(:user_id     => subscription.user_id,
                 :action_type => ProfileAction::Type::ADDED_FAVORITE_AUTHOR,
                 :entity_type => Author.to_s,
                 :entity_id   => subscription.author_id)

  end

  def self.create_removed_favorite_author_action(subscription)
    self.create!(:user_id     => subscription.user_id,
                 :action_type => ProfileAction::Type::REMOVED_FAVORITE_AUTHOR,
                 :entity_type => Author.to_s,
                 :entity_id   => subscription.author_id)

  end
  def self.create_joined_jurnalo_action(user_id)
    self.create!(:user_id         => user_id,
                 :action_type     => Type::JOINED_JURNALO)

  end

  def self.create_recommended_action(recommendation)
    action_type = (case recommendation.resource_type
                   when 'Rawstory'
                     ProfileAction::Type::RECOMMENDED_ARTICLE 
                   when 'Author'
                     ProfileAction::Type::RECOMMENDED_AUTHOR
                   else
                     nil
                   end)
    self.create!(:user_id         => recommendation.recommender_id,
                 :action_type     => action_type,
                 :entity_type     => recommendation.resource_type,
                 :entity_id       => recommendation.resource_id,
                 :receiver_user_id => recommendation.user_id)

  end

  def self.create_liked_article_action(user_id, article_id)
    existing_action = self.find(:first,
                                :conditions => ["user_id = :user_id and action_type = :liked_artcle and entity_type = :article and entity_id = :article_id and created_at > :yesterday",
                                                {:user_id => user_id,
                                                 :liked_artcle => ProfileAction::Type::LIKED_ARTICLE,
                                                 :article      => 'Rawstory',
                                                 :article_id   => article_id,
                                                 :yesterday    => (Time.now - 1.day)
                                                 }
                              ])
    return existing_action if existing_action
    self.create!(:user_id         => user_id,
                 :action_type     => ProfileAction::Type::LIKED_ARTICLE,
                 :entity_type     => 'Rawstory',
                 :entity_id       => article_id)
  end

  def self.create_liked_author_action(user_id, author_id)
    existing_action = self.find(:first,
                                :conditions => ["user_id = :user_id and action_type = :liked_author and entity_type = :author and entity_id = :author_id and created_at > :yesterday",
                                                {:user_id => user_id,
                                                 :liked_author => ProfileAction::Type::LIKED_AUTHOR,
                                                 :author      => 'Author',
                                                 :author_id   => author_id,
                                                 :yesterday    => (Time.now - 1.day)
                                                 }
                              ])

    return existing_action if existing_action
    self.create!(:user_id         => user_id,
                 :action_type     => ProfileAction::Type::LIKED_AUTHOR,
                 :entity_type     => 'Author',
                 :entity_id       => author_id)
  end

end
