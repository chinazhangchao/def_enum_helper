
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'def_enum_helper/version'

Gem::Specification.new do |spec|
  spec.name          = 'def_enum_helper'
  spec.version       = DefEnumHelper::VERSION
  spec.authors       = ['Charles Zhang']
  spec.email         = ['gis05zc@163.com']

  spec.summary       = 'define very powerful enum class'
  spec.homepage      = 'https://github.com/chinazhangchao/def_enum_helper'

  spec.files         =
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
end
