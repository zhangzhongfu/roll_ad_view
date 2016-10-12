Pod::Spec.new do |s|

  s.name         = "ad_spec"
  s.version      = "0.0.1"
  s.summary      = “循环滚动的广告视图~”

  s.license      = "MIT"

  s.author       = { "zzf" => "zzf@buduobushao.com" }
  # s.platform   = :ios, “7.0”

  s.source       = { :git => "git@github.com:zhangzhongfu/roll_ad_view.git", :tag => "#{s.version}" }

  s.source_files  = "AdScroll、*”
  # s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  s.frameworks = "UIKit", "Foundation"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

end
