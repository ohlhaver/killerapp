#!/usr/bin/env ruby
require File.dirname(__FILE__) + "/../config/environment"
def create_sitemap_file(objects, file_path)
  urls = objects.collect{|o| yield(o)}
  File.open(file_path, 'w') do |f|
   f.puts "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
   f.puts "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">"
   urls.each do |u|
   f.puts  "  <url>"
   f.puts  "    <loc>#{u}</loc>"
   f.puts  "    <changefreq>daily</changefreq>"
   f.puts  "  </url>"
   end
   f.puts "</urlset>"
  end
end

def create_site_map_index(file_names,file_path)
  sitemaps = file_names.collect{|fl| yield(fl)}
  File.open(file_path, 'w') do |f|
     f.puts "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
     f.puts "<sitemapindex xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">"
     sitemaps.each do |s|
     f.puts "  <sitemap>"
     f.puts "    <loc>#{s[0]}</loc>"
     f.puts "    <lastmod>#{s[1].to_s(:db)}</lastmod>"
     f.puts "  </sitemap>"
     end
     f.puts "</sitemapindex>"
  end
end

authors  = Author.find(:all,
                       :select => "id",
                       :order => "id ASC")
dir_name = "#{File.dirname(__FILE__)}/../public/site_maps"
i = 0
file_names = []
while true
  as = authors[(i*10000),10000]
  break if as.blank?
  create_sitemap_file(as, "#{dir_name}/authors_e_#{i}.xml"){|a| "http://www.jurnalo.com/authors/#{a.id}?l=e"}
  file_names << "#{dir_name}/authors_e_#{i}.xml"
  create_sitemap_file(as, "#{dir_name}/authors_d_#{i}.xml"){|a| "http://www.jurnalo.com/authors/#{a.id}?l=d"}
  file_names << "#{dir_name}/authors_d_#{i}.xml"
  i += 1
end

create_site_map_index(file_names, "#{dir_name}/index.xml"){|fl| [File.basename(fl),File.atime(fl).to_date]}
