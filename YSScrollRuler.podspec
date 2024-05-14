#
# Be sure to run `pod lib lint YSScrollRuler.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YSScrollRuler'
  s.version          = '0.1.3'
  s.summary          = 'scroll ruler view.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    A scroll Ruler view commonly used in the financial industry.
                       DESC

  s.homepage         = 'https://github.com/Joseph Koh/YSScrollRuler'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Joseph Koh' => 'peanutgao@hotmail.com' }
  s.source           = { :git => 'https://github.com/peanutgao/YSScrollRuler.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'

  s.source_files = 'YSScrollRuler/Classes/**/*'
  
   s.resource_bundles = {
     'YSScrollRuler' => ['YSScrollRuler/PrivacyInfo.xcprivacy']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
