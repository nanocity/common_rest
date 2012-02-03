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
