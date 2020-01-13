lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cpc/version'

Gem::Specification.new do |spec|
  spec.name          = "cpc"
  spec.version       = Cpc::VERSION
  spec.authors       = ["Alexander Garber"]
  spec.email         = ["clockworkpc@gmail.com"]

  spec.summary       = "The CPC Toolbox"
  spec.description   = "A collection of useful modules, classes, and methods."
  spec.homepage      = "http://www.clockworkpc.com.au"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/clockworkpc/cpc-ruby"
    spec.metadata["changelog_uri"] = "https://github.com/clockworkpc/cpc-ruby"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "dotenv", "~> 2.7"
  spec.add_runtime_dependency "rainbow", "~> 3.0"
  spec.add_runtime_dependency 'pry'
  spec.add_runtime_dependency 'clipboard'
  spec.add_runtime_dependency 'csv'
  spec.add_runtime_dependency 'fileutils'
  spec.add_runtime_dependency 'nokogiri'
  spec.add_runtime_dependency 'docker-api'
  spec.add_runtime_dependency 'google-api-client'
  spec.add_runtime_dependency 'facets'
  spec.add_runtime_dependency 'activesupport'
end
