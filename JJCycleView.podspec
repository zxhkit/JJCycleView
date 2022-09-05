#
# Be sure to run `pod lib lint JJCycleView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JJCycleView'
  s.version          = '0.4.0'
  s.summary          = 'This is a simple wireless loop scrolling view, very practical, written in the SWIFT language.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/zxhkit/JJCycleView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xuanhe' => '820331062@qq.com' }
  s.source           = { :git => 'https://github.com/zxhkit/JJCycleView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.platform     = :ios, '10.0'
  s.swift_version = '5.0'
  s.source_files = 'JJCycleView/Classes/**/*'
  s.requires_arc = true
  # s.resource_bundles = {
  #   'JJCycleView' => ['JJCycleView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit', 'Foundation'
  # s.dependency 'AFNetworking', '~> 2.3'
#   s.dependency 'Kingfisher', '~> 6.3.1'

end
