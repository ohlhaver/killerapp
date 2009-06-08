class RecommendationsController < ApplicationController
  before_filter :login_required
  def recommend_article
    @article = params[:id].blank? ? nil :  Rawstory.find(params[:id])
    if @article.nil?
      redirect_to :back
      return
    end
    if request.post?
      friends_to_recommend =  params[:friends_to_recommend].to_a
      if !friends_to_recommend.blank?
        friends_to_recommend.each{|user_id| 
          Recommendation.create_article_recommendation(@article.id, @current_user.id, user_id)
        } 
        flash[:notice] = "The selected friend(s) have been notified of your recommendation" if @language == 1
        flash[:notice] = "The selected friend(s) have been notified of your recommendation" if @language == 2
      end
      redirect_to_last_page_viewed_or_default(:controller => 'groups', :action => 'index', :l => @l)
      return
    end
  end
  def recommend_author
    @author = params[:id].blank? ? nil :  Author.find(params[:id])
    if @author.nil?
      redirect_to :back
      return
    end

    if request.post?
      friends_to_recommend =  params[:friends_to_recommend].to_a
      if !friends_to_recommend.blank?
        friends_to_recommend.each{|user_id| 
          Recommendation.create_author_recommendation(@author.id, @current_user.id, user_id)
        } 
        flash[:notice] = "The selected friend(s) have been notified of your recommendation" if @language == 1
        flash[:notice] = "The selected friend(s) have been notified of your recommendation" if @language == 2
      end
      redirect_to_last_page_viewed_or_default(:controller => 'groups', :action => 'index', :l => @l)
      return
    end

  end
  def view_articles
    @recommendations = Recommendation.from_valid_users(@current_user.article_recommendations, @current_user.jurnalo_friends)
    render :action => 'view'
  end
  def view_authors
    @recommendations = Recommendation.from_valid_users(@current_user.author_recommendations, @current_user.jurnalo_friends)
    render :action => 'view'
  end
  def view
    @recommendations =  Recommendation.from_valid_users(@current_user.recommendations, @current_user.jurnalo_friends)
    render :action => 'view'
  end
end
