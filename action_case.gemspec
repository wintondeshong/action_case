# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'action_case/version'

Gem::Specification.new do |gem|
  gem.name          = "action_case"
  gem.version       = ActionCase::VERSION
  gem.authors       = ["Winton DeShong"]
  gem.email         = ["contact@wintondeshong.com"]
  gem.description   = %q{Use-case driven design for ruby projects. Keeps your business logic in the right place!}
  gem.summary       = %q{Use-case driven design for ruby projects. Keeps your business logic in the right place!}
  gem.homepage      = "https://github.com/wintondeshong/action_case"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
