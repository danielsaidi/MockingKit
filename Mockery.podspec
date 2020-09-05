Pod::Spec.new do |s|
  s.name             = 'Mockery'
  s.version          = '0.6.0'
  s.swift_versions   = ['5.1']
  s.summary          = 'Mockery is a mocking library for Swift.'
  s.description      = 'Mockery contains mocking utilities for Swift.'

  s.homepage         = 'https://github.com/danielsaidi/Mockery'
  s.license          = { :type => 'NONE', :file => 'LICENSE' }
  s.author           = { 'Daniel Saidi' => 'daniel.saidi@gmail.com' }
  s.source           = { :git => 'https://github.com/danielsaidi/Mockery.git', :tag => s.version.to_s }

  s.swift_version = '5.1'
  s.ios.deployment_target = '9.0'
  s.source_files = 'Sources/Mockery/**/*.swift'
end
