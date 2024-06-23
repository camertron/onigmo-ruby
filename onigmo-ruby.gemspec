$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'onigmo/version'

Gem::Specification.new do |s|
  s.name     = 'onigmo'
  s.version  = ::Onigmo::VERSION
  s.authors  = ['Cameron Dutro']
  s.email    = ['camertron@gmail.com']
  s.homepage = 'http://github.com/camertron/onigmo-ruby'
  s.description = s.summary = 'The Onigmo regular expression engine compiled to WASM and wrapped in a Ruby embrace.'
  s.platform = Gem::Platform::RUBY

  s.add_dependency 'wasmtime', '~> 20.0'

  s.require_path = 'lib'

  s.files = Dir['{lib,test,vendor}/**/*', 'Gemfile', 'LICENSE', 'CHANGELOG.md', 'README.md', 'Rakefile', 'onigmo-ruby.gemspec']
end
