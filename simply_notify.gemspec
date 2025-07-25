Gem::Specification.new do |spec|
  spec.name          = 'simply_notify'
  spec.version       = '0.1.0'
  spec.summary       = 'Pluggable notification delivery engine'
  spec.authors       = ['Sergiu Beșliu']
  spec.email         = ['hello@wyodeb.io']
  spec.files         = Dir['lib/**/*.rb']
  spec.require_paths = ['lib']
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.license = 'MIT'
end
