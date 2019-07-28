Pod::Spec.new do |s|
  s.name             = 'FSBaseController'
  s.version          = '0.0.7'
  s.summary          = 'FSBaseController is a tool for show logs when app run'
  s.description      = <<-DESC
		This is a very small software library, offering a few methods to help with programming.
    DESC

  s.homepage         = 'https://github.com/fuchina/FSBaseController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'fudon' => '1245102331@qq.com' }
  s.source           = { :git => 'https://github.com/fuchina/FSBaseController.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.2'
  s.source_files = 'FSBaseController/Classes/*'
  
  s.dependency   'FSUIKit'
  s.dependency   'FSTrack'
  s.dependency   'FSKit'
  
  s.frameworks = 'UIKit'

end
