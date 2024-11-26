#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint supa_architecture.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'supa_architecture'
  s.version          = '0.0.1'
  s.summary          = 'Architecture library for Supa\'s Flutter applications'
  s.description      = <<-DESC
Architecture library for Supa's Flutter applications
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }

  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '11.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
