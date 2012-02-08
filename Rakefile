require 'rake'
require 'rspec/core/rake_task'
require 'yard'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts= '--format doc --color'
end

YARD::Rake::YardocTask.new('doc') do |t|
  t.files   = [ './lib/**/*' ]
  t.options = [ '-m','markdown', '-r' , 'README.markdown' ]
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "common_rest"
    gem.summary = %Q{ Gem to make easy to publish REST resources with Sinatra and Mongoid. }
    gem.description = %Q{ Gem to make easy to publish REST resources with Sinatra and Mongoid. }
    gem.email = "lciudad@nosolosoftware.biz"
    gem.homepage = "http://github.com/nanocity/common_rest"
    gem.authors = ["Luis Ciudad"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install   jeweler"
end
