Pod::Spec.new do |s|

  s.name = "WWorkApi"
  s.version = "0.16"
  s.license = {
    :type => "Copyright",
    :text => "Copyright (c) 2020 Tencent. All rights reserved.\n"
  }
  s.summary = "WWorkApi for Cocoapods convenience."
  s.homepage = "https://work.weixin.qq.com/api/doc/90000/90138/91074"
  s.authors = {
    "Tencent" => "weixinapp@qq.com"
  }
  s.source = {
    :git => "https://github.com/Uhouzz/WWorkSDK.git",
    :tag => s.version
  }
  s.platform = :ios, "8.0"
  s.source_files = "WWorkApi/*.h"
  s.public_header_files = "WWorkApi/*.h"
  s.vendored_libraries = "WWorkApi/*.a"
  s.requires_arc = false
  s.frameworks = 'SystemConfiguration','CoreTelephony', "Security", "WebKit", "CoreTelephony", "CFNetwork", "UIKit"
  s.libraries = 'z', 'sqlite3.0', 'c++'

end