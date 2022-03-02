Pod::Spec.new do |s|
  s.name             = 'DolyameSDK'
  s.summary          = 'Dolyame SDK for iOS'

  s.version          = '1.0.0'

  s.authors = {
    'Isaac Weisberg' => 'a.vaysberg@tinkoff.ru',
    'Mikhail Kogan'  => 'm.kogan@tinkoff.ru',
    'Aleksandr Tonkhonoev' => 'a.tonkhonoev@tinkoff.ru'
  }

  s.homepage         = 'https://github.com/Tinkoff/dolyamesdk-ios'

  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.source           = { git: 'https://github.com/Tinkoff/dolyamesdk-ios.git', tag: s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.ios.vendored_frameworks = "Framework/#{s.name}.xcframework"
  s.resources = [
    "Framework/#{s.name}.xcframework/ios-arm64/#{s.name}.framework/#{s.name}Images.bundle"
  ]

  # Dependencies
  s.dependency 'SnapKit', '~> 5.0.1'
  s.dependency 'Keyboard+LayoutGuide', '~> 1.6.0'
  s.dependency 'TPKeyboardAvoiding', '~> 1.3.5'
  s.dependency 'Insecurity', '~> 3.0.1'
  s.dependency 'Kingfisher', '~> 7.1.1'
  s.dependency 'KingfisherWebP', '~> 1.4.0'
  s.dependency 'TinkoffASDKCore', '~> 3.0.0-alpha7'
  s.dependency 'TinkoffASDKUI', '~> 3.0.0-alpha7'
  s.dependency 'Amplitude', '~> 8.5.0'
  s.dependency 'GzipSwift', '~> 5.1.1'
  s.dependency 'SwiftyJSON', '~> 5.0.1'
end
