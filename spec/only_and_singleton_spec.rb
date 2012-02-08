require File.dirname(__FILE__) + '/spec_helper'

describe "Singleton and only options" do
  include Rack::Test::Methods
  
  class Resource
    include Mongoid::Document
    field :name,  type: String
  end
  
  describe "Only show singleton method" do
    class OnlyShowSingleton < Sinatra::Base 
      register Sinatra::CommonRest
      configure { Mongoid.configure { |config| config.master = Mongo::Connection.new.db("common_rest") } }
      before { content_type 'application/json' }

      publish_resource Resource, :singleton => true, :only => [:show]
    end

    def app
      @app ||= OnlyShowSingleton
    end

    it "Should response only to show method" do
      resource = Resource.create!( name: "Wilfred" )

      get "/resources"
      last_response.should be_not_found

      get "/resource"
      last_response.should_not be_not_found

      get "/resource/#{resource._id}"
      last_response.should be_not_found
      
      post "/resource", { :resource => { :name => "John" }}.to_json 
      last_response.should be_not_found

      put "/resource", { :resource => { :name => "John" }}.to_json 
      last_response.should be_not_found
      
      delete "/resources/#{resource._id}" 
      last_response.should be_not_found

      delete "/resource" 
      last_response.should be_not_found
      
      Resource.delete_all
    end
  end
  
  describe "Not create non-singleton methods even with only explicitly set" do
    class SingletonAndList < Sinatra::Base 
      register Sinatra::CommonRest
      configure { Mongoid.configure { |config| config.master = Mongo::Connection.new.db("common_rest") } }
      before { content_type 'application/json' }

      publish_resource Resource, :singleton => true, :only => [:show, :list]
    end

    def app
      @app ||= SingletonAndList
    end

    it "Should response only to show method" do
      resource = Resource.create!( name: "Wilfred" )

      get "/resources"
      last_response.should be_not_found

      get "/resource"
      last_response.should_not be_not_found

      get "/resource/#{resource._id}"
      last_response.should be_not_found
      
      post "/resource", { :resource => { :name => "John" }}.to_json 
      last_response.should be_not_found

      put "/resource", { :resource => { :name => "John" }}.to_json 
      last_response.should be_not_found
      
      delete "/resources/#{resource._id}" 
      last_response.should be_not_found

      delete "/resource" 
      last_response.should be_not_found
      
      Resource.delete_all
    end
  end
end 
