require 'sinatra/base'
require 'mongoid'
require 'active_support/inflector'

module Sinatra

  module CommonRest  
    def publish_resource( klass, options = {} )
     
      class_name_s =  klass.name.split( "::" ).last.downcase 
      class_name   = class_name_s.pluralize

      default = {
        :id => "_id"
        }.merge( options )

      # GET Methods
      get "/#{class_name}" do 
        klass.all.to_json
      end

      get "/#{class_name}/:id" do
        resource = klass.where( default[:id] => params[:id] ).first
        return 404 if not resource
        resource.to_json
      end

      post "/#{class_name}" do
        request.body.rewind
        begin
          data = JSON.parse( request.body.read )
        rescue
          return [400,headers,""]
        end

        begin
          resource = klass.create!( data[class_name_s] )
        rescue Exception
          return [403, headers, ""]
        end

        url = "#{request.scheme}://#{request.host}:#{request.port}/#{class_name}/#{resource._id}"
        [201, headers, url]
      end
     
      put "/#{class_name}/:id" do
        request.body.rewind
        begin        
          data = JSON.parse( request.body.read )
        rescue Exception
          return [400, headers, ""]
        end

        resource = klass.find_or_create_by( default[:id] => params[:id] )

        begin
          resource.update_attributes!( data[class_name] )
        rescue Exception
          return [403, headers, ""]
        end

        return [205, headers, ""]
      end

      delete "/#{class_name}/:id" do
        resource = klass.where( { default[:id] => params[:id] }.to_json ).first
        
        #ResourceNotFound if not resource
        
        resource.delete
      end
    end
  end

  register CommonRest
end
