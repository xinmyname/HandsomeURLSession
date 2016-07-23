Pod::Spec.new do |s|

  s.name              = "HandsomeURLSession"
  s.version           = "1.1.2"
  s.summary           = "NSURLSession extension that provides tasks for common HTTP responses (UTF8 text, images, JSON and XML) and synchronous API"
  s.homepage          = "https://github.com/xinmyname/HandsomeURLSession"
  s.license           = "MIT"
  s.author            = { "Andy Sherwood" => "xinmyname@gmail.com" }
  s.social_media_url  = "http://twitter.com/xinmyname"
  s.requires_arc      = true

  s.ios.deployment_target     = "9.0"
  s.osx.deployment_target     = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target    = "9.0"

  s.source        = { :git => "https://github.com/xinmyname/HandsomeURLSession.git", :tag => "#{s.version}" }
  s.source_files  = "Sources/*.{h,m}"

end
