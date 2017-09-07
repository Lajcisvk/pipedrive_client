Gem::Specification.new do |spec|
  spec.name        = 'pipedrive_client'
  spec.version     = '0.0.1'
  spec.date        = '2017-09-06'
  spec.summary     = 'Pipedrive client'
  spec.description = 'Gem for communicating with pipedrive API'
  spec.authors     = ['Jan Mosat']
  spec.email       = 'mosat@weps.cz'
  spec.files       = %w(lib/pipedrive_client.rb lib/helpers/pipedrive_helpers.rb)
  spec.add_runtime_dependency 'typhoeus', '~> 1.0', '>= 1.0.1'
  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 12.0 '
  spec.homepage      = 'https://github.com/Lajcisvk/pipedrive_client'
  spec.license       = 'MIT'
end