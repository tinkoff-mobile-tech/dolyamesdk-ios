Pod::Spec.new do |s|
  s.name             = 'DolyameSDK'
  s.summary          = 'Dolyame SDK for iOS'

  s.version          = '1.0.17'

  s.authors = {
    'Isaac Weisberg' => 'a.vaysberg@tinkoff.ru',
    'Mikhail Kogan'  => 'm.kogan@tinkoff.ru',
    'Aleksandr Tonkhonoev' => 'a.tonkhonoev@tinkoff.ru'
  }

  s.homepage         = 'https://github.com/Tinkoff/dolyamesdk-ios'

  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.source           = { git: 'https://github.com/Tinkoff/dolyamesdk-ios.git', tag: s.version.to_s }

  s.ios.deployment_target = '12.3'
  s.swift_version = '5.0'

  s.ios.vendored_frameworks = ["Framework/#{s.name}.xcframework"]
end
