# Установка

### Установка через CocoaPods

Добавьте в Podfile:
```ruby
pod 'DolyameSDK'
```

### Установка через Carthage

Добавьте в Cartfile:
```
binary "https://raw.githubusercontent.com/Tinkoff/dolyamesdk-ios/main/DolyameSDK.json"
binary "https://raw.githubusercontent.com/Tinkoff/dolyamesdk-ios/main/JuicyScoreCarthageSpec.json"
```

Затем вызовите
```
carthage bootstrap --use-xcframeworks
```

Затем добавьте:

- `./Carthage/Build/DolyameSDK.xcframework`
- `./Carthage/Build/JuicyScoreFramework.xcframework` 

в `Frameworks, Libraries and Embedded Content` своего таргета приложения.

