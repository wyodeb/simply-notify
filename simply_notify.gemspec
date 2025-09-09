# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'simply_notify'
  spec.version       = '0.1.1'
  spec.summary       = 'Pluggable notification delivery engine'
  spec.description   = 'Demo notification engine with pluggable channels (email, sms, in-app), a thread-safe delivery log, and a JSON-driven CLI demo.'
  spec.authors       = ['Sergiu Beșliu']
  spec.email         = ['hello@wyodeb.io']

  spec.files         = Dir['lib/**/*.rb']
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.7'
  spec.license = 'MIT'

  spec.metadata = {
    'homepage_uri' => 'https://github.com/wyodeb/simply_notify',
    'source_code_uri' => 'https://github.com/wyodeb/simply_notify'
  }

  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 13.0'
end
