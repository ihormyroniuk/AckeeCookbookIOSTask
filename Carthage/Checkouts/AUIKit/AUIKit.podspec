Pod::Spec.new do |s|

  s.name         = "AUIKit"
  s.version      = "0.1.2"
  s.summary      = "Advanced UIKit."
  s.description  = "Advanced UIKit approach."
  s.homepage     = "https://github.com/ihormyroniuk/AUIKit"

  s.license      = "MIT"

  s.author       = { "Ihor Myroniuk" => "ihormyroniuk@gmail.com" }

  s.platform     = :ios, "10.0"

  s.source       = { :git => "https://github.com/ihormyroniuk/AUIKit.git", 
:tag => "0.1.2" }

  s.source_files = "AUIKit/**/*.{swift}"

  s.swift_version = "4.2"

end
