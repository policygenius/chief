# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chief/version'

Gem::Specification.new do |spec|
  spec.name          = 'chief'
  spec.version       = Chief::VERSION
  spec.authors       = ['Ian Yamey']
  spec.email         = ['ian@policygenius.com']

  spec.summary       = 'A simple Command Object pattern for Ruby'
  spec.homepage      = 'https://github.com/policygenius/chief'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.4'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry'
end
