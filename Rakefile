require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "importer"
    gem.summary = %Q{Import objects from external files}
    gem.description = %Q{Define new objects or modifications of existing ones in external file (xml, csv, etc) and import them to your application. Importer will not only import all the objects but also will give you detailed summary of the import process.}
    gem.email = "michal.szajbe@gmail.com"
    gem.homepage = "http://github.com/szajbus/importer"
    gem.authors = ["Michał Szajbe"]
    gem.add_dependency "crack", ">= 0.1.6"
    gem.add_dependency "fastercsv", ">= 1.5.0"
    gem.add_development_dependency "activerecord", ">= 0"
    gem.add_development_dependency "mongo_mapper", ">= 0.7.0"
    gem.add_development_dependency "thoughtbot-shoulda", ">= 0"
    gem.add_development_dependency 'sqlite3-ruby'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "importer #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
