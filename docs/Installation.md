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
```

Затем вызовите
```
carthage bootstrap --use-xcframeworks
```

Затем добавьте:

- `./Carthage/Build/DolyameSDK.xcframework`

в `Frameworks, Libraries and Embedded Content` своего таргета приложения.

### Установка через Swift Package Manager

Добавьте пакет используя URL: `https://github.com/tinkoff-mobile-tech/dolyamesdk-ios`.
Укажите необходимую версию, либо ветку `main`.