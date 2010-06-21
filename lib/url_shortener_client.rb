require 'rest_client'
require 'json'
class UrlShortenerClient
  class << self
    attr_reader :environment
    attr_reader :server
    
    def environment=(env)
      yaml = File.open(File.join(File.dirname(__FILE__), '..', 'config', 'url_shortener_config.yml')) { |f| YAML.load(f) }
      @environment = env
      @server = yaml[env.to_s]['server']
    end
    
    def create(url)
      results = JSON.parse site["/"].post({ :url => url })
      results
    end
    
    def stats(short_url_id)
      results = JSON.parse site["/stats/#{short_url_id}"].get
      results
    end
    
    private
    
    def site
      RestClient::Resource.new(server)
    end
  end
end