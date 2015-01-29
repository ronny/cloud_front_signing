# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cloud_front_signing/version'

Gem::Specification.new do |spec|
  spec.name          = "cloud_front_signing"
  spec.version       = CloudFrontSigning::VERSION
  spec.authors       = ["Ronny Haryanto"]
  spec.email         = ["ronny@haryan.to"]
  spec.summary       = %q{Generate AWS CloudFront signed URLs.}
  spec.description   = %q{Generate AWS CloudFront signed URLs.}
  spec.homepage      = "https://github.com/ronny/cloud_front_signing"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry", "~> 0.10.1"
  spec.add_development_dependency "rspec", "~> 3.1.0"

  spec.add_dependency "addressable", '~> 2.3.6'
  spec.add_dependency "yajl-ruby", '~> 1.2.1'
end
