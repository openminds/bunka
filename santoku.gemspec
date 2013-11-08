Gem::Specification.new do |spec|
  spec.name = 'santoku'
  spec.version = '0.0.1'
  spec.executables << 'santoku'
  spec.date = '2013-10-01'
  spec.summary = "Parrallel ssh commands over chef servers with rspec-like output"
  spec.description = "A gem to perform command over parrallel ssh connections on multiple chef serverspec. Output is rspec-like."
  spec.authors = ["Steven De Coeyer"]
  spec.email = 'steven@banteng.be'
  spec.files = ["lib/santoku.rb"]
  spec.homepage = 'https://github.com/zhann/santoku'
  spec.license = 'MIT'

  spec.add_dependency 'colorize'
  spec.add_dependency 'peach'
  spec.add_dependency 'ridley'
end
