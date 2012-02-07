require File.dirname(__FILE__) + '/spec_helper'

describe Sinatra::CommonRest do
  include Rack::Test::Methods

  class Resource
    include Mongoid::Document

    field :name,  type: String
    field :age,   type: Integer
    field :birth, type: Date

    validates_uniqueness_of :name
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
    before :all do
      @resource = Resource.create!( name: "Luis", age: 24, birth: Date.new( 1987, 2, 11) )
    end

    it "Should create a get '/resources' route" do
      get "/resources"
      last_response.should_not be_not_found
    end

    it "Should create a get '/resources/:id' route" do
      get "/resources/#{@resource._id}"
      last_response.should_not be_not_found
    end

    it "Should create a post '/resources' route" do
      post "/resources"
      last_response.should_not be_not_found
    end

    it "Should create a put '/resources/:id' route" do
      put "/resources/#{@resource._id}"
      last_response.should_not be_not_found
    end

    it "Should create a delete '/example_models/:id' route" do
      delete "/resources/#{@resource._id}"
      last_response.should_not be_not_found
    end

    after :all do
      Resource.delete_all
    end
  end

  describe "Internal functionality" do
    
    describe "get /resources" do
      
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

    describe "get /resources/:id" do
      before :all do
       @res1 = Resource.create!( name: "Luis", age: 24, birth: Date.new( 1987, 2, 11) )
       @res2 = Resource.create!( name: "Manolo", age: 13, birth: Date.new( 1998, 5, 15) )
      end

      it "Should retrieve information about the given resource" do
        get "/resources/#{@res1._id}"

        last_response.errors.should == ""
        last_response.headers["Content-Type"].should == "application/json;charset=utf-8"
        last_response.status.should == 200
        
        data = JSON.parse( last_response.body )
        response_resource = Resource.new( data );

        response_resource.name.should == "Luis"
        response_resource.age.should == 24
        response_resource.birth.should == Date.new( 1987, 2, 11 )
       
        get "/resources/#{@res2._id}"

        last_response.errors.should == ""
        last_response.headers["Content-Type"].should == "application/json;charset=utf-8"
        last_response.status.should == 200
        
        data = JSON.parse( last_response.body )
        response_resource = Resource.new( data );

        response_resource.name.should == "Manolo"
        response_resource.age.should == 13
        response_resource.birth.should == Date.new( 1998, 5, 15 )
      end

      it "Should retrieve an error code 404 if the resource does not exist" do
        resource = Resource.where( _id: "1234567890" ).first.should be_nil

        get "/resources/1234567890" # That resource should not exist 

        last_response.errors.should == ""
        last_response.headers["Content-Type"].should == "application/json;charset=utf-8"
        last_response.status.should == 404
      end

      after :all do
        Resource.delete_all
      end
    end
    
    describe "post /resources" do
      it "Create a new resource if parameters meet the resource validations" do
        post "/resources", { :resource => { 
          :name => "Alfonso", 
          :age => 34, 
          :birth => Date.new( 1968, 1, 2) 
        }}.to_json

        scheme = last_request.scheme
        host = last_request.host
        port = last_request.port
        url = "#{scheme}://#{host}:#{port}/resources/"

        last_response.errors.should == ""
        last_response.headers["Content-Type"].should == "application/json;charset=utf-8"
        last_response.status.should == 201
        last_response.body.should =~ /^#{url}([a-z0-9]{24})$/
      end

      it "Should retrieve an error code 403 if the parameters do not meet resource validations" do
        post "/resources", { :resource => { 
          :name => "RepeatedName", 
          :age => 34, 
          :birth => Date.new( 1968, 1, 2) 
        }}.to_json
        
        last_response.status.should == 201
        
        # Duplicate name!
        post "/resources", { :resource => { 
          :name => "RepeatedName", 
          :age => 34, 
          :birth => Date.new( 1968, 1, 2) 
        }}.to_json

        last_response.errors.should == ""
        last_response.headers["Content-Type"].should == "application/json;charset=utf-8"
        last_response.status.should == 403
      end

      it "Should retrieve an error code 400 if the request has malformed syntax" do
        post "/resources", { :resource => { 
          :name => "RepeatedName", 
          :age => 34, 
          :birth => Date.new( 1968, 1, 2) 
        }} # .to_json not perform!!! sending a regular ruby Hash 
        
        last_response.errors.should == ""
        last_response.headers["Content-Type"].should == "application/json;charset=utf-8"
        last_response.status.should == 400
      end

      after :all do
        Resource.delete_all
      end
    end

    describe "put /resources/:id" do
      it "Create a new resource if parameters meet the resource validations and the URL is known" do
        put "/resources/12345678901234567890aaaa", { :resource => { 
          :name => "Alfonso", 
          :age => 34, 
          :birth => Date.new( 1968, 1, 2) 
        }}.to_json

        last_response.errors.should == ""
        last_response.status.should == 204
        # No Content-Type needed cause 204 - No Content
        last_response.body.should be_empty

        get "/resources/12345678901234567890aaaa"
        
        resource = Resource.new( JSON.parse( last_response.body ) )
        resource.name.should == "Alfonso"
        resource.age.should == 34
        resource.birth.should == Date.new( 1968, 1, 2 )
      end

      it "Should retrieve an error code 403 if the parameters do not meet resource validations" do
        post "/resources", { :resource => { 
          :name => "RepeatedName", 
          :age => 34, 
          :birth => Date.new( 1968, 1, 2) 
        }}.to_json
        
        post "/resources", { :resource => { 
          :name => "NonRepeatedName", 
          :age => 34, 
          :birth => Date.new( 1968, 1, 2) 
        }}.to_json
        
        last_response.status.should == 201

        # Return the last posted resource
        get last_response.body

        # Create the resource
        resource = Resource.new( JSON.parse( last_response.body ) )

        # Duplicate name!
        put "/resources/#{resource._id}", { :resource => { 
          :name => "RepeatedName", 
          :age => 34, 
          :birth => Date.new( 1968, 1, 2) 
        }}.to_json

        last_response.errors.should == ""
        last_response.headers["Content-Type"].should == "application/json;charset=utf-8"
        last_response.status.should == 403
      end

      it "Should retrieve an error code 400 if the request has malformed syntax" do
        post "/resources", { :resource => { 
          :name => "RepeatedName", 
          :age => 34, 
          :birth => Date.new( 1968, 1, 2) 
        }}.to_json 
        
        last_response.status.should == 201
        
        # Return the last posted resource
        get last_response.body

        # Create the resource
        resource = Resource.new( JSON.parse( last_response.body ) )

        put "/resources/#{resource._id}", { :resource => { 
          :name => "Name", 
          :age => 34, 
          :birth => Date.new( 1968, 1, 2) 
        }} # .to_json not perform!!! sending a regular ruby Hash 
        
        last_response.errors.should == ""
        last_response.headers["Content-Type"].should == "application/json;charset=utf-8"
        last_response.status.should == 400
      end

      after :each do
        Resource.delete_all
      end
    end

    describe "delete /resource/:id" do
      it "Should delete a resource given a valid id" do
        post "/resources", { :resource => { 
          :name => "RepeatedName", 
          :age => 34, 
          :birth => Date.new( 1968, 1, 2) 
        }}.to_json 
        
        last_response.status.should == 201
        
        # Return the last posted resource
        get last_response.body

        # Create the resource
        resource = Resource.new( JSON.parse( last_response.body ) )

        delete "/resources/#{resource._id}"

        last_response.errors.should == ""
        # No Content-Type needed cause 204 - No Content
        last_response.status.should == 204
        last_response.body.should be_empty

        get "/resources/#{resource._id}"

        last_response.status.should == 404
      end

      it "Should retreieve an error code 404 if the resource does not exists" do
        post "/resources", { :resource => { 
          :name => "RepeatedName", 
          :age => 34, 
          :birth => Date.new( 1968, 1, 2) 
        }}.to_json 
        
        last_response.status.should == 201
        
        # Return the last posted resource
        get last_response.body

        # Create the resource
        resource = Resource.new( JSON.parse( last_response.body ) )

        delete "/resources/#{resource._id}"

        last_response.errors.should == ""
        # No Content-Type needed cause 204 - No Content
        last_response.status.should == 204
        last_response.body.should be_empty

        get "/resources/#{resource._id}"
        last_response.status.should == 404

        delete "/resources/#{resource._id}"
        last_response.status.should == 404
      end

      after :each do
        Resource.delete_all
      end
    end
  end
end

