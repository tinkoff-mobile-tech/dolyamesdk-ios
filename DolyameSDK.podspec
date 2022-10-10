Pod::Spec.new do |s|
  s.name             = 'DolyameSDK'
  s.summary          = 'Dolyame SDK for iOS'

  s.version          = '1.0.14'

  s.authors = {
    'Isaac Weisberg' => 'a.vaysberg@tinkoff.ru',
    'Mikhail Kogan'  => 'm.kogan@tinkoff.ru',
    'Aleksandr Tonkhonoev' => 'a.tonkhonoev@tinkoff.ru'
  }

  s.homepage         = 'https://github.com/Tinkoff/dolyamesdk-ios'

  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.source           = { git: 'https://github.com/Tinkoff/dolyamesdk-ios.git', tag: s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'
  s.ios.vendored_frameworks = ["Framework/#{s.name}.xcframework", "Framework/JuicyScoreFramework.xcframework"]
  s.resources = [
    "Framework/#{s.name}.xcframework/ios-arm64/#{s.name}.framework/#{s.name}Images.bundle"
  ]
  s.frameworks = "CFNetwork", "Accelerate"
end
