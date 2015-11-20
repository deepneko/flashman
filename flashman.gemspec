# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flashman/version'

Gem::Specification.new do |spec|
  spec.name          = "flashman"
  spec.version       = Flashman::VERSION
  spec.authors       = ["deepneko"]
  spec.email         = ["deep.inu@gmail.com"]

  spec.summary       = %q{Record your live console/terminal log in a gif file.}
  spec.homepage      = "https://github.com/deepneko/flashman"
  spec.license       = "MIT"
  spec.required_ruby_version = ">=1.9"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  #if spec.respond_to?(:metadata)
  #  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  #else
  #  raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  #end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", ">= 0"
  spec.add_runtime_dependency "sys-proctable", ">= 0.9.9"
  spec.add_runtime_dependency "slop", ">= 4.2.0"
end
