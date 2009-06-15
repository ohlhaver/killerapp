class Rawstory < ActiveRecord::Base
  
  attr_accessor :age, :weight, :blub, :position, :score, :related
  
  belongs_to :group
  belongs_to :author
  belongs_to :feedpage
  belongs_to :source
  belongs_to :haufen
  has_one    :rawstory_detail
  has_one    :rawstories_story_image
  is_indexed :fields       =>[{:field => :title},
                              {:field => :body},
                              {:field => :opinion},
                              {:field => :author_id},
                              {:field => :language},
                              {:field => :created_at}],
             :include =>[{:association_name => 'rawstory_detail', :field => 'is_duplicate', :as => 'is_duplicate'}],
             :delta => true
  def subsciption_type
    self.feedpage.subscription_type
  end
  class << self
    def find_en_keywords(text)
      raw_text = text.gsub(/, |\. |“|”|; | - |_|\n+|\\|\"|\(|\)/, ' ')
      ignore_kw = ['jan','feb','mar','apr','may','jun','jul', 'aug','sep','oct','nov','dec',    
                   'monday','tuesday','wednesday','thursday','friday','saturday','sunday',
                   'a','ap','about','an','am','and','are','at','as', 
                   'be','but','by', 
                   'can',
                   'do','does', 
                   'for','from','got', 
                   'has','have','he','her','him',
                   'if','ii','in','into','is','it',
                   'no','not','now',
                   'of','off','on','out','over', 
                   'she','should','so','some', 
                   'that','the','their','them','there','they','this','to',
                   'under','up',
                   'you',
                   'was','we','what','when','which','who','will','with']
      raw_keywords = raw_text.split(/\s+/)
      raw_keywords.reject! do |kw|
        ignore_kw.include?(kw.downcase)
      end
      count_hashed = raw_keywords.inject(Hash.new(0)) {|h,x| h[x]+=1;h}
      sorted_keys  = count_hashed.keys.sort_by{|k| count_hashed[k]}
      sorted_keys
    end
    def find_de_keywords(text)
      raw_text = text.gsub(/, |\. |“|”|; | - |_|\n+|\\|\"|\(|\)/, ' ')
      raw_keywords = raw_text.split(/\s+/)
      raw_keywords.reject! do |kw|
        kw.match(/[A-Z]/).nil?
      end
      count_hashed = raw_keywords.inject(Hash.new(0)) {|h,x| h[x]+=1;h}
      sorted_keys  = count_hashed.keys.sort_by{|k| count_hashed[k]}
      sorted_keys
    end
  end
  
  def all_keywords
    if defined?(@all_keywords)
      return @all_keywords
    end
    if self.language == 2
      @all_keywords = Rawstory.find_de_keywords(self.title.to_s + ' ' + self.body.to_s)
    else
      @all_keywords = Rawstory.find_en_keywords(self.title.to_s + ' ' + self.body.to_s)
    end
    return @all_keywords
  end

end
