Gem::Specification.new do |spec|
  spec.name = 'santoku'
  spec.version = '0.0.4'
  spec.executables << 'santoku'
  spec.date = '2013-11-17'
  spec.summary = "Parrallel ssh commands over chef servers with rspec-like output"
  spec.description = "A gem to perform command over parallel ssh connections on multiple chef serverspec. Output is rspec-like."
  spec.authors = ["Steven De Coeyer", "Mike Morraye"]
  spec.email = 'tech@openminds.be'
  spec.files = ["lib/santoku.rb"]
  spec.homepage = 'https://github.com/zhann/santoku'
  spec.license = 'MIT'

  spec.add_dependency 'colorize'
  spec.add_dependency 'peach'
  spec.add_dependency 'ridley'
  spec.add_dependency 'thor'
end
