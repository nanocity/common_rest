require 'sinatra/base'
require 'mongoid'

module Sinatra

  module CommonRest  
    def publish_resource( klass, options = {} )
     
      class_name = klass.name.split( "::" ).last.downcase
      default = {
        :id => "id"
        }
      
      default.merge( options )

      # GET Methods
      get "/#{class_name}s" do 
        klass.all.to_json
      end

      get "/#{class_name}s/:id" do
        resource = klass.where( { default[:id] => params[:id] }.to_json ).first
        resource.to_json
        #ResourceNotFound if not resource
      end

      post "/#{class_name}s" do
        request.body.rewind

        data = JSON.parse( request.body.read )
        klass.create!( data[class_name] )
      end
     
      put "/#{class_name}s/:id" do
        requet.body.rewind

        data = JSON.parse( request.body.read )
        resource = klass.where( {default[:id] => params[:id] }.to_json ).first

        #ResourceNotFound if not resource

        resource.update_attributes!( data[class_name] )
      end

      delete "/#{class_name}s/:id" do
        resource = klass.where( { default[:id] => params[:id] }.to_json ).first
        
        #ResourceNotFound if not resource
        
        resource.delete
      end
    end
  end

  register CommonRest
end
