require File.dirname(__FILE__) + '/spec_helper'

describe "Singleton Resources" do
  include Rack::Test::Methods
  
  class Resource
    include Mongoid::Document
    field :name,  type: String

    validates_format_of :name, with: /^[a-zA-Z]+$/
  end
  
  describe "Full Singleton" do
    class FullSingleton < Sinatra::Base 
      register Sinatra::CommonRest
      configure { Mongoid.configure { |config| config.master = Mongo::Connection.new.db("common_rest") } }
      before { content_type 'application/json' }

      publish_resource Resource, :singleton => true
    end

    def app
      @app ||= FullSingleton
    end

    it "Should response only to certain non-pluralized methods" do
      resource = Resource.create!( name: "Wilfred" )

      get "/resource"
      last_response.should_not be_not_found

      get "/resource/#{resource._id}"
      last_response.should be_not_found
      
      post "/resource", { :resource => { :name => "John" }}.to_json 
      last_response.should be_not_found

      put "/resource", { :resource => { :name => "John" }}.to_json 
      last_response.should_not be_not_found
      
      delete "/resource" 
      last_response.should_not be_not_found
    end
    
    it "Should show the resource" do
      Resource.create!( name: "Wilfred" )

      get "/resource"
      last_response.should_not be_not_found
      
      resource = Resource.new( JSON.parse( last_response.body ) )
      resource.name.should == "Wilfred"
    end
    
    it "Should return an error code 404 if the resources has not been created" do
      get "/resource"
      last_response.should be_not_found

      last_response.errors.should == ""
      last_response.headers["Content-Type"].should == "application/json;charset=utf-8"
      last_response.status.should == 404
    end
    
    it "Should update the resource if it does exists" do
      Resource.create!( name: "Wilfred" )

      put "/resource", { :resource => { :name => "Jhon" }}.to_json
      last_response.errors.should == ""
      last_response.status.should == 204

      get "/resource"
      resource = Resource.new( JSON.parse( last_response.body ) )
      resource.name.should == "Jhon"
    end

    it "Should update the resource even if it does not exists" do
      put "/resource", { :resource => { :name => "Jhon" }}.to_json
      last_response.errors.should == ""
      last_response.status.should == 204

      get "/resource"
      resource = Resource.new( JSON.parse( last_response.body ) )
      resource.name.should == "Jhon"
    end
    
    it "Should return an error 400 if the parameters has bad syntax" do
      put "/resource", { :resource => { :name => "Jhon" }}
      last_response.errors.should == ""
      last_response.status.should == 400
    end
    
    it "Should return an error 403 if the parameters has invalid values" do
      put "/resource", { :resource => { :name => "Amparo1996" }}.to_json
      last_response.errors.should == ""
      last_response.status.should == 403
    end

    it "Should delete the resource" do
      put "/resource", { :resource => { :name => "Wilfdred" }}.to_json
      last_response.errors.should == ""
      last_response.status.should == 204

      delete "/resource"
      last_response.errors.should == ""
      last_response.status.should == 204

      get "/resource"
      last_response.should be_not_found
      last_response.errors.should == ""
      last_response.status.should == 404
    end

    it "Should retrieve an error code 404 if there are no resource to delete" do
      delete "/resource"
      last_response.should be_not_found
      last_response.errors.should == ""
      last_response.status.should == 404
    end

    after :each do
      Resource.delete_all
    end
  end
end 
