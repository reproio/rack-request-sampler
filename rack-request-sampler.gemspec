
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rack/request/sampler/version"

Gem::Specification.new do |spec|
  spec.name          = "rack-request-sampler"
  spec.version       = Rack::Request::Sampler::VERSION
  spec.authors       = ["woshidan"]
  spec.email         = ["bibro.pcg@gmail.com"]

  spec.summary       = %q{Rack middleware for sampling requests with the specified rate and handling it.}
  spec.homepage      = "https://github.com/reproio/rack-request-sampler"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rack-test", "~> 0.7"
end
