# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pepin/version'

Gem::Specification.new do |spec|
  spec.name          = 'pepin'
  spec.version       = Pepin::VERSION
  spec.authors       = ['hibariya']
  spec.email         = ['hibariya@gmail.com']

  spec.summary       = %q{Interactive filtering tool for CLI written in Ruby.}
  spec.homepage      = 'https://github.com/hibariya/pepin'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'curses',   '~> 1.0.1'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.3.0'
end
