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
    @recommendations =  @current_user.recommendations.find_all{|r| r.active and r.article?}
    render :action => 'view'
  end
  def view_authors
    @recommendations =  @current_user.recommendations.find_all{|r| r.active and r.author?}
    render :action => 'view'
  end
  def view
    @recommendations =  @current_user.recommendations.find_all{|r| r.active}
    render :action => 'view'
  end
end
