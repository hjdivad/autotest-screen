require 'rubygems'
require 'rake'

Dir[ 'lib/tasks/**/*' ].each{ |l| require l }


begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "autotest-screen"
    gem.summary = %Q{Update Gnu Screen caption with autotest results.}
    gem.description = %Q{
      Update Gnu Screen caption with autotest results.

      Specifically, when autotest is running with an ancestor [Gnu] screen
      process, have that screen's caption set when autotest runs tests.

      Conceptually similar to autotest-growl but with a different notification system.
    }
    gem.email = "autotest-screen@hjdivad.com"
    gem.homepage = "http://github.com/hjdivad/autotest-screen"
    gem.authors = ["David J. Hamilton"]

    if File.exists? 'Gemfile'
      require 'bundler'
      bundler = Bundler.load
      bundler.dependencies_for( :runtime ).each do |dep|
        gem.add_dependency              dep.name, dep.requirement.to_s
      end
      bundler.dependencies_for( :development ).each do |dep|
        gem.add_development_dependency  dep.name, dep.requirement.to_s
      end
    end

    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end


desc "Write out build version.  You must supply BUILD."
task 'version:write:build' do
  unless ENV.has_key? 'BUILD'
    abort "Must supply BUILD=<build> to write out build version number." 
  end
  y = YAML::load_file( "VERSION.yml" )
  v = {
    :major => 0, :minor => 0, :patch => 0, :build => 0
  }
  v.merge!( y ) if y.is_a? Hash
  v[ :build ] = ENV['BUILD']
  File.open( "VERSION.yml", "w" ){|f| f.puts YAML::dump( v )}
end

task 'version:bump:build' do
  y = YAML::load_file( "VERSION.yml" )
  v = {
    :major => 0, :minor => 0, :patch => 0, :build => 0
  }
  v.merge!( y ) if y.is_a? Hash

  raise "Can't bump build: not a number" unless v[:build].is_a? Numeric
  v[ :build ] += 1

  v.each{|k,v| ENV[ k.to_s.upcase ] = v.to_s}
  Rake::Task["version:write"].invoke
end


desc "Run all specs."
task :spec do
  sh "rspec spec"
end


begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
