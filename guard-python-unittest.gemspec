# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "guard-python-unittest"
  gem.version       = "0.1.0"
  gem.authors       = ["Konstantin Tennhard"]
  gem.email         = ["me@t6d.de"]
  gem.summary       = "Guard for executing Python unit tests"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency("guard", "~> 1.0")
end
