
Pod::Spec.new do |s|
  s.name         = "RNKakaoLink"
  s.version      = "1.0.0"
  s.summary      = "RNKakaoLink"
  s.description  = <<-DESC
                  RNKakaoLink
                   DESC
  s.homepage     = "n/a"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/shpongle2634/react-native-kakao-links.git", :tag => "master" }
  s.source_files  = "*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  # s.dependency 'KakaoOpenSDK'
  #s.dependency "others"

end
