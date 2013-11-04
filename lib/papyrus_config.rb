require 'ostruct'
require 'singleton'

class PapyrusConfig
  include Singleton
      
  attr_accessor :organization, :authentication, :errors, :notifications, :bib_search
  
  DEFAULT_ORGANIZATION =  { full_name: "Your Institution/Department Name", short_name: "SHORT_NAME", app_url: "http://your-institution.website/papyrus/" }
  DEFAULT_AUTHENTICATION = {  
    cas_header_name:  "REMOTE-USER", 
    after_logout_redirect_to: "http://www.your-instituttion.website", 
    cookies_domain: "your-domain.com"
  }
  
  DEFAULT_ERRORS = { 
    email_subject_prefix: "[Papyrus Error] ",
    sender_address: "'Papyrus Notifier' <papyrus-errors@your-instituttion.website>", 
    error_recipients: ["your.email@your-instituttion.email"]  
  }
                    
  DEFAULT_NOTIFICATIONS = {
  	from_email: "papyrus@your-insitution.email",
  	welcome_subject: "Welcome to Transcription Services",
  	notification_subject: "Your Institution/Department Name Transcription Services - Papyrus Notification",
  	items_assigned_subject: "Multiple items have now been assigned to you"	
  }
  
  DEFAULT_BIB_SEARCH = {
    type: "solr",
    label: "Your Catalogue",
    id_prefix: "vufind",
    url: "http://localhost:8080/solr/biblio",
    sort: [ { score: "descending" } , { _docid_: "descending" } ],
    phrase_fields: "title_txtP^100",
    boost_functions: "recip(ms(NOW,publishDateBoost_tdate),3.16e-11,1,1)^1.0",
    query_fields: "title_short_txtP^757.5   title_short^750  title_full_unstemmed^404   title_full^400   title_txtP^750   title^500   title_alt_txtP_mv^202   title_alt^200   title_new_txtP_mv^101   title_new^100   series^50   series2^30   author^500   author_fuller^150   contents^10   topic_unstemmed^404   topic^400   geographic^300   genre^300   allfields_unstemmed^10   fulltext_unstemmed^10   allfields isbn issn"
  }
  
  
  def initialize
    @organization = OpenStruct.new DEFAULT_ORGANIZATION
    @authentication = OpenStruct.new DEFAULT_AUTHENTICATION
    @errors = OpenStruct.new DEFAULT_ERRORS
    @notifications = OpenStruct.new DEFAULT_NOTIFICATIONS
    @bib_search = OpenStruct.new DEFAULT_BIB_SEARCH                       
  end
  
  def self.reset_defaults
    PapyrusConfig.instance.organization = OpenStruct.new DEFAULT_ORGANIZATION
    PapyrusConfig.instance.authentication = OpenStruct.new DEFAULT_AUTHENTICATION
    PapyrusConfig.instance.errors = OpenStruct.new DEFAULT_ERRORS
    PapyrusConfig.instance.notifications = OpenStruct.new DEFAULT_NOTIFICATIONS
    PapyrusConfig.instance.bib_search = OpenStruct.new DEFAULT_BIB_SEARCH                           
  end
  
  ### CONFIGURE the instance for the startup
  def self.configure(&block)
    yield PapyrusConfig.instance
  end
  
  ### Access configuration object
  def self.config
    PapyrusConfig.instance
  end
  
  ## Class method shortcuts for instance objects, auto defining these methods using a SELF call to define
  %w(organization authentication errors notifications bib_search).each do |method|
    self.class.send(:define_method, "#{method}".downcase) do      # use param
      return PapyrusConfig.instance.send(method).clone
     end
   end
end


### EXAMPLE

# PapyrusConfig.configure do |config|
#  config.errors.sender_address = "my-error-sender@your-institution.com"
# end

