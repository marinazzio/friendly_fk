lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'friendly_fk/version'

Gem::Specification.new do |spec|
  spec.name          = 'friendly_fk'
  spec.version       = FriendlyFk::VERSION
  spec.authors       = ['Denis Kiselyov']
  spec.email         = ['denis.kiselyov@gmail.com']
  spec.license       = 'MIT'
  spec.summary       = 'Creates foreign keys with friendly names'
  spec.description   = 'Uses parent and child table names to create FK with neat ids'
  spec.homepage      = 'https://github.com/marinazzio/friendly_fk'

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/marinazzio/friendly_fk/issues',
    'documentation_uri' => 'https://github.com/marinazzio/friendly_fk/blob/master/README.md',
    'homepage_uri' => 'https://github.com/marinazzio/friendly_fk',
    'source_code_uri' => 'https://github.com/marinazzio/friendly_fk',
    'rubygems_mfa_required' => 'true'
  }

  spec.required_ruby_version = '>= 3.2.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord'
end
