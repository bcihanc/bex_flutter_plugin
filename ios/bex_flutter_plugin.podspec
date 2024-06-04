#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name = 'bex_flutter_plugin'
  s.version = '0.0.1'
  s.summary = 'BKM Express Flutter plugin.'
  s.description = <<-DESC
BKM Express Flutter plugin.
                       DESC
  s.homepage = 'http://example.com'
  s.license = { :file => '../LICENSE' }
  s.author = { 'Your Company' => 'email@example.com' }
  s.source = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'

  s.ios.deployment_target = '9.0'

  s.dependency 'Flutter'
  s.dependency 'BKMExpressSDK', '1.2.12'
end
