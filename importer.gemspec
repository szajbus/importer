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
  gem.add_development_dependency "activerecord", ">= 0"
  gem.add_development_dependency "mongo_mapper", ">= 0.7.0"
  gem.add_development_dependency "dm-core", ">= 0.10.2"
  gem.add_development_dependency "dm-validations", ">= 0.10.2"
  gem.add_development_dependency "dm-aggregates", ">= 0.10.2"
  gem.add_development_dependency "dm-sqlite-adapter", ">= 0.10.2"
  gem.add_development_dependency "do_sqlite3", ">= 0.10.1.1"
  gem.add_development_dependency "shoulda", ">= 0"
  gem.add_development_dependency "sqlite3-ruby", ">= 0"
  gem.add_development_dependency "rr", ">= 0"
end

