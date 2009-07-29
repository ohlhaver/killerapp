class SiteMapAuthorSubCategory < ActiveRecord::Base
  belongs_to :category,
             :class_name => 'SiteMapAuthorCategory',
             :foreign_key => 'category_id'
  has_many :site_map_category_author_maps,
           :foreign_key => 'sub_category_id'
  has_many :authors,
           :through => :site_map_category_author_maps
end
