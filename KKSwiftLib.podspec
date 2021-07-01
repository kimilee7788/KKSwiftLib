#
# Be sure to run `pod lib lint KKSwiftLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KKSwiftLib'
  s.version          = '0.3.4'
  s.summary          = 'A short description of KKSwiftLib.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/kimilee7788/KKSwiftLib'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kimilee7788' => '35053358+kimilee7788@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/kimilee7788/KKSwiftLib.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'
  
  s.subspec 'KM_Extension' do |ss|
  s.source_files = 'KKSwiftLib/CLasses/Extension'
#  ss.subspec 'Protocol' do |sss|
#  sss.source_files = 'KKSwiftLib/CLasses/Extension/Protocol'
#    end
#  ss.subspec 'FoundationExtension' do |sss|
#  sss.source_files = 'KKSwiftLib/CLasses/Extension/FoundationExtension'
##  sss.dependency 'Protocol'
#    end
#  ss.subspec 'SmallTools' do |sss|
#  sss.source_files = 'KKSwiftLib/CLasses/Extension/SmallTools'
##  sss.dependency 'Protocol'
#    end
#  ss.subspec 'UIKitExtension' do |sss|
#  sss.source_files = 'KKSwiftLib/CLasses/Extension/UIKitExtension'
##  sss.dependency 'Protocol'
#    end
#  end
#  s.subspec 'Base' do |ss|
#  ss.source_files = 'KKSwiftLib/CLasses/Base'
#  ss.subspec 'controller' do |sss|
#  sss.source_files = 'KKSwiftLib/CLasses/Base/controller'
#  sss.dependency 'KM_Extension'
#    end
#  ss.subspec 'views' do |sss|
#  sss.source_files = 'KKSwiftLib/CLasses/Base/views'
#  sss.dependency 'KM_Extension'
#    end
#  ss.subspec 'config' do |sss|
#  sss.source_files = 'KKSwiftLib/CLasses/Base/config'
#  sss.dependency 'KM_Extension'
#    end
  end
  
#  s.subspec 'controller' do |ss|
#  ss.source_files = 'KKSwiftLib/CLasses/controller'
#  end
#  s.subspec 'FoundationExtension' do |ss|
#  ss.source_files = 'KKSwiftLib/CLasses/FoundationExtension'
#  end
#  s.subspec 'Protocol' do |ss|
#  ss.source_files = 'KKSwiftLib/CLasses/Protocol'
#  end
#  s.subspec 'SmallTools' do |ss|
#  ss.source_files = 'KKSwiftLib/CLasses/SmallTools'
#  end
#  s.subspec 'UIKitExtension' do |ss|
#  ss.source_files = 'KKSwiftLib/CLasses/UIKitExtension'
#  end
#  s.subspec 'views' do |ss|
#  ss.source_files = 'KKSwiftLib/CLasses/views'
  # s.resource_bundles = {
  #   'KKSwiftLib' => ['KKSwiftLib/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit','QuartzCore','CoreMedia'
   s.dependency 'EmptyStateKit'
   s.dependency 'EFMarkdown'
   s.dependency 'SnapKit'
#   s.dependency 'DKImagePickerController', :subspecs => ['PhotoGallery']

end
