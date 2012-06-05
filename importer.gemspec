# -*- encoding: utf-8 -*-
require File.expand_path('../lib/importer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Micha\xC5\x82 Szajbe"]
  gem.email         = ["michal.szajbe@gmail.com"]
  gem.description   = %q{Define new objects or modifications of existing ones in external file (xml, csv, etc) and import them to your application. Importer will not only import all the objects but also will give you detailed summary of the import process.}
  gem.summary       = %q{Import objects from external files}
  gem.homepage      = %q{http://github.com/szajbus/importer}

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "importer"
  gem.require_paths = ["lib"]
  gem.version       = Importer::VERSION

  gem.add_runtime_dependency "crack", ">= 0.1.6"
  gem.add_runtime_dependency "fastercsv", ">= 1.5.0"
  gem.add_development_dependency "activerecord", "3.2.5"
  gem.add_development_dependency "mongo_mapper", "0.11.1"
  gem.add_development_dependency "datamapper", "1.2"
  gem.add_development_dependency "dm-sqlite-adapter", "1.2"
  gem.add_development_dependency "do_sqlite3", "0.10.8"
  gem.add_development_dependency "thoughtbot-shoulda", "2.11.1"
  gem.add_development_dependency "sqlite3-ruby", "1.3.3"
  gem.add_development_dependency "rr", "1.0.4"
end

