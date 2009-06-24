class HomePageConf < ActiveRecord::Base
  belongs_to :user

  class Status
    MAXIMIZED = 0 # Default
    DELETED   = 1
  end

  def deleted?(section_name)
    eval("self.#{section_name}_section_status == #{Status::DELETED}")
  end

  def maximized?(section_name)
    eval("self.#{section_name}_section_status == #{Status::MAXIMIZED}")
  end

  def add_section(section_name)
    eval("self.#{section_name}_section_status = #{Status::MAXIMIZED}")
    self.save!
  end

  def delete_section(section_name)
    eval("self.#{section_name}_section_status = #{Status::DELETED}")
    self.save!
  end

  def all_sections_deleted?
    all_section_names = ['top_stories','politics','business','culture','science','technology','sport','mixed','opinions']     
    deleted = true
    i = 0
    while i < all_section_names.size and deleted
      deleted = deleted and deleted?(all_section_names[i])
    end
    return deleted
  end
end
