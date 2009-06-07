class Extension < ActiveRecord::Base
  has_permalink :name  
  belongs_to :author, :class_name => 'User', :foreign_key => :user_id, :counter_cache => true
  has_and_belongs_to_many :versions
  
  acts_as_taggable
  
  validates_presence_of :name, :summary, :scm_location
#  validates_uniqueness_of :name, :scm_location
  validates_url_of :website, :message => 'is not valid or not responding', :enable_http_check => true  
  
  named_scope :recent, lambda { |*args| {:limit => (args.first || 3), :order => 'created_at DESC'} }  

  def owned_by(user)
    self.author == user
  end
  
  def github?
    scm_location =~ /github.com/    
  end
 
  # for search support
  #
  acts_as_xapian :texts => [:name, :summary, :description, :extra_search_texts]
  
  def extra_search_texts
    ''
  end

  attr_accessor :search_percent
  attr_accessor :search_weight

  def self.search(query, options = {})
    options = {:per_page => 10}.update(options)
    options[:page] ||= 1
    
    total_matches = ActsAsXapian::Search.new([Extension], query, :limit => options[:per_page]).matches_estimated
    total_pages = (total_matches / options[:per_page].to_f).ceil
   
    offset = options[:per_page] * (options[:page].to_i - 1)
    # really need this second call? look at it sometime
    xapian_search = ActsAsXapian::Search.new([Extension], query, :limit => options[:per_page], :offset => offset)

    objects = xapian_search.results.map do |result|
      object = result[:model]
      object.search_percent = result[:percent]
      object.search_weight = result[:weight]
      object
    end

    returning XapianResultEnumerator.new(options[:page], options[:per_page], total_matches) do |pager|
      pager.xapian_search = xapian_search
      pager.replace objects
    end
  end

end
