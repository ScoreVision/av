# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'av/version'

Gem::Specification.new do |spec|
  spec.name          = "av"
  spec.version       = Av::VERSION
  spec.authors       = ["Omar Abdel-Wahab"]
  spec.email         = ["owahab@gmail.com"]
  spec.summary       = %q{Programmable Ruby interface for FFMPEG/Libav}
  spec.description   = %q{Programmable Ruby interface for FFMPEG/Libav}
  spec.homepage      = "https://github.com/ruby-av"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 3.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.6"
  spec.add_development_dependency "rake", "~> 13.2"
  spec.add_development_dependency "rspec", "~> 3.4.0"
  spec.add_development_dependency "coveralls", "~> 0.8"

  spec.add_dependency "terrapin", "~> 1.1.0"
end
