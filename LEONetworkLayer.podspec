Pod::Spec.new do |s|
  s.name             = 'LEONetworkLayer'
  s.version          = '2.0'  
  s.summary          = "Network layer for iOS apps with Magora\'s Leopold protocol"
  s.homepage         = 'https://github.com/Magora-IOS/LEONetworkLayer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author          = { 'Magora iOS department' => 'yursavitskiy@gmail.com' }
  s.source           = { :git => 'https://github.com/Magora-IOS/LEONetworkLayer.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'

  s.dependency 'Moya/RxSwift', '~> 14.0'

  s.source_files = 'LeoNetworkLayer/**/*.{swift}'  
  s.swift_version = "5.0"
  s.cocoapods_version = '>= 1.4.0'
end
