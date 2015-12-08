# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mediainfo-ruby}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Martinez (http://github.com/hackerdude/)", "Felix Gilcher"]
  s.date = %q{2010-10-06}
  s.description = %q{MediaInfo Ruby Bridge. Call MediaInfo lib directly}
  s.email = %q{felix.gilcher@asquera.de}
  s.files = Dir.glob('lib/**/*.rb') + ['mediainfo-ruby.gemspec'] + Dir.glob('ext/**/*.{rb,cpp}')
  
  s.extensions = ["ext/mediainfo_ruby/extconf.rb"]
  
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.homepage = %q{http://github.com/castaclip/mediainfo-ruby}
  
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{MediaInfo Ruby Bridge. Call MediaInfo lib directly}
  s.add_dependency "rice" #, "1.4.2"
  
  s.add_development_dependency('rspec')
  
  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3
  end
end

