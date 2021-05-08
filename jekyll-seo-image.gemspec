Gem::Specification.new do |s|
  s.name        = 'jekyll-seo-image'
  s.version     = '0.0.0'
  s.summary     = "Scales and adds logo to open graph image"
  s.description = "A simple plugin to modify post images forOpen Graph images with logo"
  s.authors     = ["Joe Irving"]
  s.email       = 'joe@irving.me.uk'
  s.files       = ["lib/jekyll-seo-image.rb"]
  # s.homepage    = 'https://rubygems.org/gems/hola'
  s.license       = 'MIT'

  s.add_runtime_dependency 'mini_magick'
  s.add_runtime_dependency 'jekyll'
end
