class SiteMapAuthorCategory < ActiveRecord::Base
  has_many :sub_categories,
          :class_name => 'SiteMapAuthorSubCategory',
          :foreign_key => 'category_id'
  has_many :site_map_category_author_maps,
           :foreign_key => 'category_id'
  has_many :authors,
           :through => :site_map_category_author_maps

end
