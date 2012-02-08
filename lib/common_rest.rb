require 'sinatra/base'
require 'mongoid'
require 'active_support/inflector'

module Sinatra

  module CommonRest  
    def publish_resource( klass, options = {} )
     
      class_name_s =  klass.name.split( "::" ).last.downcase 
      class_name   = class_name_s.pluralize

      default = {
        :id => "_id",
        :only => [:show, :list, :create, :update, :delete],
        :singleton => false
        }.merge( options )

      if !default[:singleton] and default[:only].include? :list
          get "/#{class_name}" do 
            klass.all.to_json
          end
      end

      if default[:only].include? :show
        if default[:singleton]
          get "/#{class_name_s}" do
            resource = klass.all.first
            return 404 if not resource
            resource.to_json
          end
        else
          get "/#{class_name}/:id" do
            resource = klass.where( default[:id] => params[:id] ).first
            return 404 if not resource
            resource.to_json
          end
        end
      end

      if !default[:singleton] and default[:only].include? :create
        post "/#{class_name}" do
          request.body.rewind
          begin
            data = JSON.parse( request.body.read )
          rescue
            return [ 400, headers, "" ]
          end

          begin
            resource = klass.create!( data[class_name_s] )
          rescue Exception
            return [ 403, headers, "" ]
          end

          url = "#{request.scheme}://#{request.host}:#{request.port}/#{class_name}/#{resource._id}"
          [ 201, headers, url ] 
        end
      end

      if default[:only].include? :update
        if default[:singleton]
          put "/#{class_name_s}" do
            request.body.rewind
            begin        
              data = JSON.parse( request.body.read )
            rescue Exception
              return [ 400, headers, "" ]
            end
            
            begin
              resource = klass.all.first || klass.new( data[class_name_s] )
              resource.update_attributes!( data[class_name_s] )
            rescue Exception
              return [ 403, headers, "" ]
            end
            
            [ 204, headers, "" ]
          end
        else
          put "/#{class_name}/:id" do
            request.body.rewind
            begin        
              data = JSON.parse( request.body.read )
            rescue Exception
              return [ 400, headers, "" ]
            end
            
            resource = klass.find_or_create_by( default[:id] => params[:id] )

            begin
              resource.update_attributes!( data[class_name_s] )
            rescue Exception
              return [ 403, headers, "" ]
            end
            
            [ 204, headers, "" ]
          end

        end
      end

      if default[:only].include? :delete
        if default[:singleton]
          delete "/#{class_name_s}" do
            resource = klass.all.first
            return 404 if not resource
            resource.delete

            [ 204, headers, "" ]
          end
        else
          delete "/#{class_name}/:id" do
            resource = klass.where( { default[:id] => params[:id] }.to_json ).first
            return 404 if not resource 
            resource.delete
            [ 204, headers, "" ]
          end
        end
      end
    end
  end

  register CommonRest
end
