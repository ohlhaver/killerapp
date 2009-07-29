class SiteMapController < ApplicationController
  def index 
  end
  def authors
    @categories = SiteMapAuthorCategory.find(:all)
  end
  def authors_in_category
    @category = SiteMapAuthorCategory.find(params[:id])
    @sub_categories = SiteMapAuthorSubCategory.find(:all, :conditions => ["category_id = ?", params[:id].to_i], :order => "id ASC")
  end
  def authors_in_sub_category
    @sub_category = SiteMapAuthorSubCategory.find(params[:id])
    @category = SiteMapAuthorCategory.find(@sub_category.category_id) rescue nil
    c_a_maps = SiteMapCategoryAuthorMap.find(:all, 
                                             :conditions => ["sub_category_id = ?", params[:id].to_i],
                                             :select => "author_id")
    rank = {}
    c_a_maps.each_with_index do |am,i|
      rank[am.author_id] = i
    end
    author_ids = c_a_maps.collect{|am| am.author_id}*","
    @authors = []
    return if author_ids.blank?
    @authors = Author.find(:all, :select => "name,id", :conditions => "id IN ( #{ author_ids} )")
    @authors = @authors.sort_by{|a| rank[a.id]}
  end
end
