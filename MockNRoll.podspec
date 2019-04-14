Pod::Spec.new do |s|
  s.name             = 'MockNRoll'
  s.version          = '0.0.1'
  s.summary          = 'MockNRoll is a Swift mocking library.'
  s.description      = 'MockNRoll contains mock utils for Swift.'

  s.homepage         = 'https://github.com/danielsaidi/MockNRoll'
  s.license          = { :type => 'NONE', :file => 'LICENSE' }
  s.author           = { 'Daniel Saidi' => 'daniel.saidi@gmail.com' }
  s.source           = { :git => 'https://github.com/danielsaidi/MockNRoll', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'MockNRoll/**/*.swift'
end
