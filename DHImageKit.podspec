#
#  Be sure to run `pod spec lint DHImageKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "DHImageKit"
  s.version      = "1.0.0"
  s.summary      = "DHImageKit is a library that allows you to edit image easily"
  s.description  = "DHImageKit is a image editing library based on GPUImage. Providing both the abliity to add a filter to whole image and the ability to edit single component of a image"
  s.homepage     = "https://github.com/Danielhhs/DHImageKit"
  s.license      = "MIT"
  s.author             = { "Daniel Huang" => "Danielhhs@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/Danielhhs/DHImageKit.git", :tag => "#{s.version}" }
  s.source_files  = "Classes", "Classes/Source/**/*.{h,m}"
  s.resources = "Classes/Resource/*.png"
  s.exclude_files = "Classes/Exclude"
  s.requires_arc = true
  s.xcconfig = { 'CLANG_MODULES_AUTOLINK' => 'YES' }
  # s.resource  = "icon.png"
  s.frameworks = "OpenGLES", "CoreMedia", "QuartzCore", "AVFoundation"

  s.dependency "GPUImage"

end
