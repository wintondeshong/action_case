# -*- encoding: utf-8 -*-
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "action_case/version"

Gem::Specification.new do |gem|
  gem.name          = "action_case"
  gem.version       = ActionCase::VERSION
  gem.authors       = ["Winton DeShong"]
  gem.email         = ["contact@wintondeshong.com"]
  gem.description   = %q{Use-case driven design for ruby projects. Keeps your business logic in the right place!}
  gem.summary       = %q{Use-case driven design for ruby projects. Keeps your business logic in the right place!}
  gem.homepage      = "https://github.com/wintondeshong/action_case"

  gem.files         = `git ls-files`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ["lib"]

  gem.add_dependency "activesupport"

  gem.add_development_dependency "guard"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "travis-lint"
end
