$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "export_to_cloud/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "export_to_cloud"
  s.version     = ExportToCloud::VERSION
  s.authors     = ["Matt Fordham"]
  s.email       = ["matt@revolvercreative.com"]
  s.homepage    = "https://github.com/mattfordham/export_to_cloud"
  s.summary     = "TODO: Summary of ExportToCloud."
  s.description = "TODO: Description of ExportToCloud."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.3"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "fog"
  s.add_development_dependency "ruby-debug19"
end
