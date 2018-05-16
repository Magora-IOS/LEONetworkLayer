Pod::Spec.new do |s|
  s.name             = 'LEONetworkLayer'
  s.version          = '0.3.0'
  s.summary          = "Network layer for iOS apps with Magora\'s Leopold protocol"
  s.homepage         = 'https://github.com/Magora-IOS/LEONetworkLayer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Magora iOS department' => 'rosenberg@magora-systems.com' }
  s.source           = { :git => 'https://github.com/Magora-IOS/LEONetworkLayer.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'

  s.source_files = 'LEONetworkLayer/Classes/**/*'
  
  s.dependency 'ObjectMapper', '~> 3.1.0'
  s.dependency 'Alamofire', '~> 4.7.2'
  s.dependency 'AlamofireObjectMapper', '~> 5.0.0'
end
