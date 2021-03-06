# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "common_rest"
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Luis Ciudad"]
  s.date = "2012-02-08"
  s.description = " Gem to make easy to publish REST resources with Sinatra and Mongoid. "
  s.email = "lciudad@nosolosoftware.biz"
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.files = [
    "Gemfile",
    "README.markdown",
    "Rakefile",
    "VERSION",
    "lib/common_rest.rb",
    "spec/common_rest_spec.rb",
    "spec/only_and_singleton_spec.rb",
    "spec/only_spec.rb",
    "spec/singleton_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/nanocity/common_rest"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Gem to make easy to publish REST resources with Sinatra and Mongoid."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sinatra>, ["~> 1.3.2"])
      s.add_runtime_dependency(%q<mongoid>, ["~> 2.4.2"])
      s.add_runtime_dependency(%q<activesupport>, ["~> 3.2.1"])
      s.add_runtime_dependency(%q<jeweler>, ["~> 1.8.3"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<rack-test>, ["~> 0.6.1"])
      s.add_development_dependency(%q<mongoid-rspec>, ["~> 1.4.4"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.5.4"])
      s.add_development_dependency(%q<simplecov-rcov>, ["~> 0.2.3"])
      s.add_development_dependency(%q<yard>, ["~> 0.7.4"])
    else
      s.add_dependency(%q<sinatra>, ["~> 1.3.2"])
      s.add_dependency(%q<mongoid>, ["~> 2.4.2"])
      s.add_dependency(%q<activesupport>, ["~> 3.2.1"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<rack-test>, ["~> 0.6.1"])
      s.add_dependency(%q<mongoid-rspec>, ["~> 1.4.4"])
      s.add_dependency(%q<simplecov>, ["~> 0.5.4"])
      s.add_dependency(%q<simplecov-rcov>, ["~> 0.2.3"])
      s.add_dependency(%q<yard>, ["~> 0.7.4"])
    end
  else
    s.add_dependency(%q<sinatra>, ["~> 1.3.2"])
    s.add_dependency(%q<mongoid>, ["~> 2.4.2"])
    s.add_dependency(%q<activesupport>, ["~> 3.2.1"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<rack-test>, ["~> 0.6.1"])
    s.add_dependency(%q<mongoid-rspec>, ["~> 1.4.4"])
    s.add_dependency(%q<simplecov>, ["~> 0.5.4"])
    s.add_dependency(%q<simplecov-rcov>, ["~> 0.2.3"])
    s.add_dependency(%q<yard>, ["~> 0.7.4"])
  end
end

