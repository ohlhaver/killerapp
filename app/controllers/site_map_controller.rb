class SiteMapController < ApplicationController
  def index 
  end
  def authors
    @categories = SiteMapAuthorCategory.find(:all)
  end
  def authors_in_category
    @category = SiteMapAuthorCategory.find(params[:id])
    @sub_categories = SiteMapAuthorSubCategory.find(:all, :conditions => ["category_id = ?", params[:id].to_i])
  end
  def authors_in_sub_category
    @sub_category = SiteMapAuthorSubCategory.find(params[:id])
    @category = SiteMapAuthorCategory.find(@sub_category.category_id) rescue nil
    author_ids = SiteMapCategoryAuthorMap.find(:all, :conditions => ["sub_category_id = ?", params[:id].to_i], :select => "author_id").collect{|am| am.author_id}*","
    @authors = []
    return if author_ids.blank?
    @authors = Author.find(:all, :select => "name,id", :conditions => "id IN ( #{ author_ids} )")
  end
end
