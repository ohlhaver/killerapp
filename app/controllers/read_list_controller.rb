class ReadListController < ApplicationController

  before_filter :login_required
  def add_item
    story = Rawstory.find(params[:id], :select => "id")
    if story && ReadItem.find_by_user_id_and_rawstory_id(@current_user.id, params[:id]).nil?
      ReadItem.create!(:user_id => @current_user.id, :rawstory_id => params[:id])
      flash[:notice] = "You have added the article to your reading list." if @language == 1
      flash[:notice] = "Sie haben den Artikel zu Ihrer Leseliste hinzugefügt." if @language == 2
    end
    redirect_to_last_page_viewed_or_default
  end
  def remove_item
    read_list = ReadItem.find(params[:id])
    if read_list.user_id == @current_user.id
      read_list.destroy
      flash[:notice] = "You have removed the article from your reading list." if @language == 1
      flash[:notice] = "Sie haben den Artikel von Ihrer Leseliste entfernt." if @language == 2
    end
    redirect_to_last_page_viewed_or_default
  end
  def show
    @read_list = ReadItem.find(:all, 
                               :conditions =>"user_id = #{@current_user.id}").sort_by{|r| r.created_at}.reverse
    story_ids = @read_list.collect{|r| r.rawstory_id}*','
    @rawstories_h = {}
    unless story_ids.blank?
      @rawstories_h = Rawstory.find(:all, 
                                  :conditions => ["`rawstories`.id IN ( #{story_ids} )"],
                                  :include => [:source, :author]).group_by{|s| s.id}
    end
  end
end
