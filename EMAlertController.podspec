Pod::Spec.new do |s|
  s.name             = 'EMAlertController'
  s.version          = '1.0.2'
  s.summary          = 'Elegant alert view controller alternative for iOS'

  s.description      = <<-DESC
                          EMAlertController is a beautiful alternative to the stock iOS UIAlertController. This library is fully customizable with an implementation like the native UIAlertController.
                       DESC

  s.homepage         = 'https://github.com/egmoll7/EMAlertController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Eduardo Moll' => 'egmoll7@gmail.com' }
  s.social_media_url = "http://twitter.com/egmoll7"
  s.source           = { :git => 'https://github.com/egmoll7/EMAlertController.git', :tag => s.version }

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'
  s.source_files = 'Sources/EMAlertController/**/*'

end
