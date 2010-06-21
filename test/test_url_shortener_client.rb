require 'helper'

class TestUrlShortenerClient < Test::Unit::TestCase
  context "setting up the environment" do
    setup do
      UrlShortenerClient.environment = :test
    end
    
    should "set the environment" do
      assert_equal UrlShortenerClient.environment, :test
    end
    
    should "set the server" do
      assert_equal UrlShortenerClient.server, 'http://admin:secret@di-url-shortener.local'
    end
  end
  
  context "creating short urls" do
    setup do
      UrlShortenerClient.environment = :test
      @origin_url = "http://www.google.com"
      @short_url = UrlShortenerClient.create(@origin_url)
    end
    
    should "receive a response with the origin url" do
      assert_equal @short_url["url"], @origin_url
    end
    
    should "receive a response with the short url" do
      assert_match /http\:\/\/di-url-shortener.local\/[a-zA-Z0-9+]/, @short_url["shortened_url"]
    end
    
    should "receive a response with the short_url id" do
      assert_not_nil @short_url["id"]
    end
  end
  
  context "retrieving statistics for a short url" do
    setup do
      UrlShortenerClient.environment = :test
      @origin_url = "http://www.google.com"
      @short_url = UrlShortenerClient.create(@origin_url)
    end
    
    should "receive a hash with a click count" do
      statistics = UrlShortenerClient.stats(@short_url["id"])
      assert_equal statistics["click_count"], 0
    end
    
    should "receive a hash with a click count with the correct click count" do
      site = RestClient::Resource.new(@short_url["shortened_url"])
      7.times {
        site["/"].get
      }
      statistics = UrlShortenerClient.stats(@short_url["id"])
      assert_equal statistics["click_count"], 7
    end
  end
end