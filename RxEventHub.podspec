Pod::Spec.new do |s|
  s.name             = 'RxEventHub'
  s.version          = '0.1.0'
  s.summary          = '`RxEventHub` makes multicasting event easy, type-safe and error-free, use it instead of `NSNotificationCenter` now!'

  s.description      = <<-DESC
`RxEventHub` is an event hub in `RxSwift` world, it makes multicasting event easy, type-safe and error-free, use it instead of `NSNotificationCenter` now!
                       DESC

  s.homepage         = 'https://github.com/zzdjk6/RxEventHub'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zzdjk6' => 'zzdjk6@126.com' }
  s.source           = { :git => 'https://github.com/zzdjk6/RxEventHub.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/zzdjk6'

  s.ios.deployment_target = '8.0'
  s.source_files = 'RxEventHub/Classes/**/*'
  s.dependency 'RxSwift', '~> 2.5'
end
