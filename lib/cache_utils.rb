class CacheUtils
  def self.generate_key(hash)
    key = ""
    hash.keys.sort_by{|s| s.to_s}.each do |k|
      key += "_#{k.to_s}_#{hash[k].to_s}_"
    end
    return key
  end
  class GroupsControllerCache < GroupsController
    def update_cache_index(user)
      [[1,1],[1,2],[nil,1],[nil,2]].each do |i,language|
        cache_key = CacheUtils.generate_key({:controller => 'groups',
                                              :action      => 'index',
                                              :user_id     => user.id,
                                              :i           => i,
                                              :l           => (language == 2)? 'd' : 'e'})
        searchterms = nil
        searchterms = user.searchterms.split(/\,/).reverse if  user.searchterms

        cache_read = {}
        top_my_searchterms = {}
        top_my_authors = []

        if searchterms
            searchterms.each do |s|
              top_my_searchterms[s] = fetch_my_searchterms s,i,language,user
            end
            cache_read[:top_my_searchterms]= top_my_searchterms
        end
        top_my_authors = fetch_my_authors(user)
        cache_read[:top_my_authors]= top_my_authors
        Rails.cache.write(cache_key, cache_read) unless cache_read.blank?
      end
    end
  end
end
