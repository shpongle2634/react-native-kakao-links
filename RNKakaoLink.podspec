require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = "RNKakaoLink"
  s.version      = package['version']
  s.summary      = "KakaoLink for react-native"
  s.authors      = { "author" => "yeongmok@getmiso.com" }
  s.homepage     = "https://miso.kr"
  s.license      = package['license']
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/getmiso/react-native-kakao-links.git", :tag => "#{s.version}" }
  s.source_files = "ios/**/*.{h,m}"
  s.requires_arc = true

  s.dependency 'React'
  s.dependency 'KakaoOpenSDK', '1.23.4'
end
