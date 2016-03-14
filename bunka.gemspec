Gem::Specification.new do |spec|
  spec.name = 'bunka'
  spec.version = '1.4.2'
  spec.executables << 'bunka'
  spec.date = '2013-11-26'
  spec.summary = 'Parallel ssh commands over chef servers with rspec-like output'
  spec.description = 'A gem to perform command over parallel ssh connections on multiple chef serverspec. Output is rspec-like.'
  spec.authors = ['Steven De Coeyer', 'Jeroen Jacobs']
  spec.email = 'tech@openminds.be'
  spec.files = `git ls-files`.split($\)
  spec.homepage = 'https://github.com/openminds/bunka'
  spec.license = 'MIT'

  spec.add_dependency 'chef', '>= 11.0'
  spec.add_dependency 'colorize'
  spec.add_dependency 'net-ssh'
  spec.add_dependency 'parallel'
  spec.add_dependency 'rake'
  spec.add_dependency 'thor'
  spec.add_dependency 'rest-client'
end
