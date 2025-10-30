# -*- encoding: utf-8 -*-
# stub: simplecov-rcov 0.3.7 ruby lib

Gem::Specification.new do |s|
  s.name = "simplecov-rcov".freeze
  s.version = "0.3.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Fernando Guillen http://fernandoguillen.info".freeze, "Wes Morgan http://github.com/cap10morgan".freeze, "Wandenberg Peixoto http://github.com/wandenberg".freeze]
  s.date = "2024-01-31"
  s.description = "Rcov style formatter for SimpleCov".freeze
  s.email = ["fguillen.mail@gmail.com".freeze, "cap10morgan@gmail.com".freeze]
  s.homepage = "http://github.com/fguillen/simplecov-rcov".freeze
  s.rubygems_version = "3.4.20".freeze
  s.summary = "Rcov style formatter for SimpleCov".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<simplecov>.freeze, [">= 0.4.1"])
  s.add_development_dependency(%q<bundler>.freeze, [">= 1.0.0.rc.6"])
  s.add_development_dependency(%q<mocha>.freeze, [">= 0"])
  s.add_development_dependency(%q<rake>.freeze, [">= 0"])
end
