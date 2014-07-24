$:.push File.expand_path("../lib", __FILE__)

require "simple_interactions/version"

Gem::Specification.new do |s|
  s.name        = "simple_interactions"
  s.version     = SimpleInteractions::VERSION
  s.authors     = ["Kaid"]
  s.email       = ["info@kaid.me"]
  s.homepage    = "https://github.com/mindpin/simple_interactions"
  s.summary     = "Delegate task to another client you have signed-in."
  s.description = "Delegate task to another client you have signed-in."
  s.license     = "MIT"

  s.executables = ["interaction_server"]
  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "activesupport", "~> 4.1"
  s.add_dependency "faye", "~> 1.0.3"
  s.add_dependency "thin", "~> 1.6.2"
  s.add_dependency "redis", "~> 3.1.0"
  s.add_dependency "hiredis", "~> 0.5.2"
  s.add_dependency "connection_pool", "~> 2.0.0"

  s.add_development_dependency "pry"
end
