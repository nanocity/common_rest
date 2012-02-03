require File.dirname(__FILE__) + '/spec_helper'

describe Sinatra::CommonRest do
  include Rack::Test::Methods

  class Resource
    include Mongoid::Document

    field :name,  type: String
    field :age,   type: Integer
    field :birth, type: Date
  end

  class TestApplication < Sinatra::Base 
    register Sinatra::CommonRest    
    
    configure do 
      Mongoid.configure { |config| config.master = Mongo::Connection.new.db("common_rest") }
    end
  
    before do
      content_type 'application/json'
    end

    publish_resource Resource
  end

  def app
    @app ||= TestApplication
  end

  describe "Basic operation" do
    it "Should create a get '/example_models' route" do
      get '/resources'
      last_response.should_not be_not_found
    end

    it "Should create a get '/example_models/:id' route" do
      get '/resources/1234'
      last_response.should_not be_not_found
    end

    it "Should create a post '/example_models' route" do
      post '/resources'
      last_response.should_not be_not_found
    end

    it "Should create a put '/example_models/:id' route" do
      put '/resources/1234'
      last_response.should_not be_not_found
    end

    it "Should create a delete '/example_models/:id' route" do
      delete '/resources/1234'
      last_response.should_not be_not_found
    end
  end

  describe "Internal functionality" do
    
    describe "/resources" do
      
      before :all do
        Resource.create!( name: "Luis", age: 24, birth: Date.new( 1987, 2, 11) )
        Resource.create!( name: "Manolo", age: 13, birth: Date.new( 1998, 5, 15) )
      end

      it "Should retrieve information about all resources" do
        get '/resources'

        last_response.errors.should == ""
        last_response.headers["Content-Type"].should == "application/json;charset=utf-8"
        last_response.status.should == 200
        
        data = JSON.parse( last_response.body )
        data.is_a?( Array ).should be_true
        data.length.should == 2

        res1 = Resource.new( data[0] );
        res2 = Resource.new( data[1] );

        res1.name.should == "Luis"
        res1.age.should == 24
        res1.birth.should == Date.new( 1987, 2, 11 )

        res2.name.should == "Manolo"
        res2.age.should == 13
        res2.birth.should == Date.new( 1998, 5, 15 )
      end

      it "Should return an empty array as response if there are no resources" do
        Resource.delete_all

        get '/resources'

        last_response.errors.should == ""
        last_response.headers["Content-Type"].should == "application/json;charset=utf-8"
        last_response.status.should == 200
        last_response.body.should == "[]"
        
        data = JSON.parse( last_response.body )
        data.is_a?( Array ).should be_true
        data.length.should == 0
      end

      after :all do
        Resource.delete_all
      end

    end
  end
end

