Gem::Specification.new do |s|
  s.name        = "watch"
  s.version     = File.read(File.expand_path("VERSION", __dir__)).strip
  s.summary     = "A simple directory watcher"
  s.description = "A dirt simple mechanism to tell if files have changed"
  s.authors     = ["Ben Schwarz"]
  s.email       = "ben.schwarz@gmail.com"
  s.homepage    = "https://github.com/benschwarz/watch"
  s.license     = "MIT"

  s.required_ruby_version = ">= 3.0"

  s.files         = Dir["lib/**/*.rb"] + ["LICENSE", "README.md", "VERSION"]
  s.require_paths = ["lib"]

  s.metadata = {
    "source_code_uri" => s.homepage,
    "bug_tracker_uri" => "#{s.homepage}/issues",
    "changelog_uri"   => "#{s.homepage}/releases"
  }

  s.add_development_dependency "rake", "~> 13.0"
  s.add_development_dependency "rspec", "~> 3.13"
end
