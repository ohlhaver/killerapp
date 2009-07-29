class SiteMapCategoryAuthorMap < ActiveRecord::Base
   belongs_to :author
   belongs_to :sub_category
   belongs_to :category
end
