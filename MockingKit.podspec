Pod::Spec.new do |s|
  s.name             = 'MockingKit'
  s.version          = '1.2.0'
  s.swift_versions   = ['5.6']
  s.summary          = 'MockingKit is a mocking library for Swift.'
  s.description      = 'MockingKit contains protocol mocking utilities for Swift. MockingKit makes it easy to mock protocol implementations for unit tests and to fake functionality in your Swift-based systems.'

  s.homepage         = 'https://github.com/danielsaidi/MockingKit'
  s.license          = { :type => 'NONE', :file => 'LICENSE' }
  s.author           = { 'Daniel Saidi' => 'daniel.saidi@gmail.com' }
  s.source           = { :git => 'https://github.com/danielsaidi/MockingKit.git', :tag => s.version.to_s }
  
  s.swift_version = '5.6'
  s.ios.deployment_target = '13.0'
  s.tvos.deployment_target = '13.0'
  s.macos.deployment_target = '10.15'
  s.watchos.deployment_target = '6.0'
  
  s.source_files = 'Sources/MockingKit/**/*.swift'
end
