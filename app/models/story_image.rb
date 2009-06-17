require 'RMagick'
require 'mogilefs'
class StoryImage < ActiveRecord::Base
  belongs_to :source
  THUMBNAIL_MAX_WIDTH  = 80
  THUMBNAIL_MAX_HEIGHT = 80

  def thumb_image_data
    mg = MogileFS::MogileFS.new(:domain => 'stories', :hosts => MOGILE_FS_CONFIG["hosts"].split(","))
    
    data = mg.get_file_data "thumb_#{self.id}" rescue ''
  end

  def store_image(image_data,content_type)
    @img              = Magick::Image.from_blob(image_data).to_a.first
    @thumb_img        = @img.dup
    @thumb_img.change_geometry!("#{THUMBNAIL_MAX_WIDTH}x#{THUMBNAIL_MAX_HEIGHT}"){|cols, rows, img| img.resize!(cols, rows)}
    begin
      mg                = MogileFS::MogileFS.new(:domain => 'stories', :hosts => MOGILE_FS_CONFIG["hosts"].split(","))
      mg.store_content("#{self.id}", 'images', image_data)
      mg.store_content("thumb_#{self.id}", 'images', @thumb_img.to_blob)
    rescue
       return
    end
    self.content_type = content_type.chomp
    self.dimensions   = "#{@img.columns}x#{@img.rows}"
    self.thumb_dimensions   = "#{@thumb_img.columns}x#{@thumb_img.rows}"
    self.thumb_content_type = content_type.chomp
    self.image_exists       = true
    self.save!
  end

  def remove_image
    return unless self.image_exists
    begin
      mg                = MogileFS::MogileFS.new(:domain => 'stories', :hosts => MOGILE_FS_CONFIG["hosts"].split(","))
      mg.delete "#{self.id}"
      mg.delete "thumb_#{self.id}"
    rescue
      return
    end
    self.content_type = ''
    self.dimensions = ''
    self.thumb_dimensions = ''
    self.thumb_content_type = ''
    self.image_exists = false
    self.save!
  end
end
