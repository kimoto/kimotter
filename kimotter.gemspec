# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{kimotter}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["kimoto"]
  s.date = %q{2012-01-20}
  s.default_executable = %q{kimotter}
  s.description = %q{kiomtter}
  s.email = %q{peerler@gmail.com}
  s.executables = ["kimotter", "koiketter"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/kimotter",
     "bin/koiketter",
     "lib/kimotter.rb",
     "lib/kimotter_cli.rb",
     "test/kimotter_test.rb",
     "test/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/kimoto/kimotter}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{kimotter}
  s.test_files = [
    "test/test_helper.rb",
     "test/kimotter_test.rb"
  ]

  s.add_dependency "mechanize"
  s.add_dependency "nokogiri"

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
  end
end
