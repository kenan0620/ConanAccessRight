#
# Be sure to run `pod lib lint ConanAccessRight.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ConanAccessRight'
  s.version          = '0.1.1'
  s.summary          = '对APP的权限进行获取和判断.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
对APP的权限进行获取和判断。 /* 蓝牙权限 */ / 相机权限 */ / 通讯录权限 */ / 健康分享权限 */ / 健康更新权限 */ / 智能家居权限 */ / 媒体库权限 */ / 麦克风权限 */ / 运动与健身权限 */ / 音乐权限 */ / 相册权限 */ / Siri权限 */ / 语音转文字权限 */ / 电视供应商权限 */ / 备忘录权限、日历权限 */ / 定位权限 */ / *推送权限 */
                       DESC

  s.homepage         = 'https://github.com/kenan0620/ConanAccessRight'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kenan0620' => 'houkenan0620@126.com' }
  s.source           = { :git => 'https://github.com/kenan0620/ConanAccessRight.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
s.requires_arc = true
  s.source_files = 'ConanAccessRight/*.{h,m}'
  
  # s.resource_bundles = {
  #   'ConanAccessRight' => ['ConanAccessRight/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
