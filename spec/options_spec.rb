require File.dirname(__FILE__) + '/spec_helper'

describe "Options" do
  include Rack::Test::Methods
  
  class Resource
    include Mongoid::Document
    field :name,  type: String
  end
  
  describe "Only list method" do
    class OnlyList < Sinatra::Base 
      register Sinatra::CommonRest
      configure { Mongoid.configure { |config| config.master = Mongo::Connection.new.db("common_rest") } }
      before { content_type 'application/json' }

      publish_resource Resource, :only => [:list]
    end

    def app
      @app ||= OnlyList
    end

    it "Should response only to list method" do
      resource = Resource.create!( name: "Wilfred" )

      get "/resources"
      last_response.should_not be_not_found

      get "/resources/#{resource._id}"
      last_response.should be_not_found
      
      post "/resources", { :resource => { :name => "John" }}.to_json 
      last_response.should be_not_found

      put "/resources/#{resource._id}", { :resource => { :name => "John" }}.to_json 
      last_response.should be_not_found
      
      delete "/resources/#{resource._id}" 
      last_response.should be_not_found

      Resource.delete_all
    end
  end
  
  describe "Only show method" do
    class OnlyShow < Sinatra::Base 
      register Sinatra::CommonRest
      configure { Mongoid.configure { |config| config.master = Mongo::Connection.new.db("common_rest") } }
      before { content_type 'application/json' }

      publish_resource Resource, :only => [:show]
    end

    def app
      @app ||= OnlyShow
    end

    it "Should response only to show method" do
      resource = Resource.create!( name: "Wilfred" )

      get "/resources"
      last_response.should be_not_found

      get "/resources/#{resource._id}"
      last_response.should_not be_not_found
      
      post "/resources", { :resource => { :name => "John" }}.to_json 
      last_response.should be_not_found

      put "/resources/#{resource._id}", { :resource => { :name => "John" }}.to_json 
      last_response.should be_not_found
      
      delete "/resources/#{resource._id}" 
      last_response.should be_not_found

      Resource.delete_all
    end
  end

  describe "Only create method" do
    class OnlyCreate < Sinatra::Base 
      register Sinatra::CommonRest
      configure { Mongoid.configure { |config| config.master = Mongo::Connection.new.db("common_rest") } }
      before { content_type 'application/json' }

      publish_resource Resource, :only => [:create]
    end

    def app
      @app ||= OnlyCreate
    end

    it "Should response only to create method" do
      resource = Resource.create!( name: "Wilfred" )

      get "/resources"
      last_response.should be_not_found

      get "/resources/#{resource._id}"
      last_response.should be_not_found
      
      post "/resources", { :resource => { :name => "John" }}.to_json 
      last_response.should_not be_not_found

      put "/resources/#{resource._id}", { :resource => { :name => "John" }}.to_json 
      last_response.should be_not_found
      
      delete "/resources/#{resource._id}" 
      last_response.should be_not_found

      Resource.delete_all
    end
  end
  
  describe "Only update method" do
    class OnlyUpdate < Sinatra::Base 
      register Sinatra::CommonRest
      configure { Mongoid.configure { |config| config.master = Mongo::Connection.new.db("common_rest") } }
      before { content_type 'application/json' }

      publish_resource Resource, :only => [:update]
    end

    def app
      @app ||= OnlyUpdate
    end

    it "Should response only to update method" do
      resource = Resource.create!( name: "Wilfred" )

      get "/resources"
      last_response.should be_not_found

      get "/resources/#{resource._id}"
      last_response.should be_not_found
      
      post "/resources", { :resource => { :name => "John" }}.to_json 
      last_response.should be_not_found

      put "/resources/#{resource._id}", { :resource => { :name => "John" }}.to_json 
      last_response.should_not be_not_found
      
      delete "/resources/#{resource._id}" 
      last_response.should be_not_found

      Resource.delete_all
    end
  end
  
  describe "Only delete method" do
    class OnlyDelete < Sinatra::Base 
      register Sinatra::CommonRest
      configure { Mongoid.configure { |config| config.master = Mongo::Connection.new.db("common_rest") } }
      before { content_type 'application/json' }

      publish_resource Resource, :only => [:delete]
    end

    def app
      @app ||= OnlyDelete
    end

    it "Should response only to delete method" do
      resource = Resource.create!( name: "Wilfred" )

      get "/resources"
      last_response.should be_not_found

      get "/resources/#{resource._id}"
      last_response.should be_not_found
      
      post "/resources", { :resource => { :name => "John" }}.to_json 
      last_response.should be_not_found

      put "/resources/#{resource._id}", { :resource => { :name => "John" }}.to_json 
      last_response.should be_not_found
      
      delete "/resources/#{resource._id}" 
      last_response.should_not be_not_found

      Resource.delete_all
    end
  end
  
  describe "Read methods" do
    class ReadMethods < Sinatra::Base 
      register Sinatra::CommonRest
      configure { Mongoid.configure { |config| config.master = Mongo::Connection.new.db("common_rest") } }
      before { content_type 'application/json' }

      publish_resource Resource, :only => [:list, :show]
    end

    def app
      @app ||= ReadMethods
    end

    it "Should response only to list and show methods" do
      resource = Resource.create!( name: "Wilfred" )

      get "/resources"
      last_response.should_not be_not_found

      get "/resources/#{resource._id}"
      last_response.should_not be_not_found
      
      post "/resources", { :resource => { :name => "John" }}.to_json 
      last_response.should be_not_found

      put "/resources/#{resource._id}", { :resource => { :name => "John" }}.to_json 
      last_response.should be_not_found
      
      delete "/resources/#{resource._id}" 
      last_response.should be_not_found

      Resource.delete_all
    end
  end
  
  describe "Write methods" do
    class WriteMethods < Sinatra::Base 
      register Sinatra::CommonRest
      configure { Mongoid.configure { |config| config.master = Mongo::Connection.new.db("common_rest") } }
      before { content_type 'application/json' }

      publish_resource Resource, :only => [:create, :update, :delete]
    end

    def app
      @app ||= WriteMethods
    end

    it "Should response only to create, update and delete methods" do
      resource = Resource.create!( name: "Wilfred" )

      get "/resources"
      last_response.should be_not_found

      get "/resources/#{resource._id}"
      last_response.should be_not_found
      
      post "/resources", { :resource => { :name => "John" }}.to_json 
      last_response.should_not be_not_found

      put "/resources/#{resource._id}", { :resource => { :name => "John" }}.to_json 
      last_response.should_not be_not_found
      
      delete "/resources/#{resource._id}" 
      last_response.should_not be_not_found

      Resource.delete_all
    end
  end
   
  describe "All methods" do
    class AllMethods < Sinatra::Base 
      register Sinatra::CommonRest
      configure { Mongoid.configure { |config| config.master = Mongo::Connection.new.db("common_rest") } }
      before { content_type 'application/json' }

      publish_resource Resource, :only => [:show, :list, :create, :update, :delete]
    end

    def app
      @app ||= AllMethods
    end

    it "Should response to all methods" do
      resource = Resource.create!( name: "Wilfred" )

      get "/resources"
      last_response.should_not be_not_found

      get "/resources/#{resource._id}"
      last_response.should_not be_not_found
      
      post "/resources", { :resource => { :name => "John" }}.to_json 
      last_response.should_not be_not_found

      put "/resources/#{resource._id}", { :resource => { :name => "John" }}.to_json 
      last_response.should_not be_not_found
      
      delete "/resources/#{resource._id}" 
      last_response.should_not be_not_found

      Resource.delete_all
    end
  end

end
 
