require 'rubygems'
require 'rake'

Dir[ 'lib/tasks/**/*' ].each{ |l| require l }


begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    # TODO 1: name
    gem.name = "TODO: name"
    gem.summary = %Q{TODO: description}
    gem.description = %Q{TODO: description}
    gem.email = "TODO: name @hjdivad.com"
    gem.homepage = "http://github.com/hjdivad/TODO: name"
    gem.authors = ["David J. Hamilton"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "yard", ">= 0"
    gem.add_development_dependency "cucumber", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
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
