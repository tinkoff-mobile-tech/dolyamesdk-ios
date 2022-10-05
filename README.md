# Долями iOS SDK, руководство по интеграции

## До интеграции SDK

Перед тем как интегрировать Долями SDK, вам необходимо предоставить вашему персональному менеджеру из команды Долями SDK следующие данные:

Данные|Формат|Зачем используются
---|---|---
Название магазина|Название магазина, предпочтительно чтобы вмещалось в одну строку|В нашем интерфейсе мы показываем название магазина для того чтобы пользователь знал в каком магазине он покупает
Иконка магазина|JPG/PNG, без альфа-канала или прозрачных частей, квадратный, разрешение мин. 160x160 макс. 480x480, без контента по углам, так как в дизайне углы иконки будут обрезаться до состояния круга.|Иконка магазина будет отображаться в интерфейсах SDK для того, чтобы пользователь видел в каком магазине приобретает товар

## Установка SDK
Начиная с версии 1.0.11, выключена поддержка bitcode.

### Установка через CocoaPods

Добавьте в Podfile:
```ruby
pod 'DolyameSDK'
```

### Установка через Swift Package Manager

Добавьте в `Package.json`:
```swift
.package(url: "https://github.com/Tinkoff/dolyamesdk-ios.git", .exact("1.0.13"))
```

Либо в Xcode:
- Add Packages...
- Enter Package URL
- ввести туда `https://github.com/Tinkoff/dolyamesdk-ios.git`

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

## Подготовительные работы на вашем бэкенде

Для работы с SDK от вашего бэкенда требуется ТОЛЬКО:
- поддержка [вебхука Долями](https://dolyame.ru/develop/help/webhooks/)
- умение вызывать [Commit, Cancel, Info и Refund](https://dolyame.ru/develop/help/api/) для работы с заказом

URL на который будет приходить вебхук вы можете передать вашему контакту Долями или указать в `notificationUrl`.

Для работы с SDK Долями вашему бэкенду НЕ нужно вызывать `Create`!

## Использование SDK
Минимальная версия iOS 12.0.

SDK Долями предоставляет возможность нашим клиентам интегрировать платежный флоу через сервис Долями в безопасной и эффективной манере. Под капотом, нативный приватный код SDK осуществляет менеджмент многих аспектов связанных с использованием сервиса, таких как:
- авторизация пользователя
- менеджмент платежных методов
- работа с осуществлением платежей

Однако, несмотря на сложность и закрытость имплементации, целью этого SDK является предоставление минималистичного API с единой точкой входа и единой точкой выхода, которое позволит интегрировать SDK с минимальными усилиями.

## Алгоритмика использования SDK

Для интеграции SDK нужно:
- встроить в свой интерфейс кнопку **Оплатить Долями**, класс `DolyamePaymentButton`.
- создать объект конфигурации SDK, класс `DolyamePaymentConfiguration`
- создать интанс координатора SDK, класс `DolyamePaymentCoordinator`
- подписаться на результат работы координатора, проперти, `DolyamePaymentCoordinator.onFinish`.

<p style="page-break-after: always;">&nbsp;</p>

# Секция 1: Кнопка "Оплатить Долями"

## Класс `DolyamePaymentButton`
Этот класс является саб-классом UIView и функционирует как обычная `UIView` сверстанная на AutoLayout. По дизайну, на данный момент, это широкая кнопка с текстом "Оплатить Долями" в одну строку, который помещается только в полную ширину экрана, в недалеком будущем подразумевается создание альтернативной, узкой версии которую можно будет посместить на половину ширины экрана.

Кнопка "Оплатить Долями" из коробки имеет характерный дизайн продукта Долями и не требует никакой конфигурации.

Не ставье `NSLayoutConstaint` на высоту кнопки Долями. Доверьтесь той высоте, которую кнопка хочет сама по себе.

При нажатии на кнопку будет вызван event handler `onButtonPressed`, который приложение интегратор выставляет на инстансе кнопки через проперти `DolyamePaymentButton.onButtonPressed`.
```swift
public class DolyamePaymentButton: UIView {
    public var onButtonPressed: (() -> Void)?
}
```

Этот хэндлер будет вызываться при каждом нажатии на кнопку и в результате работы этого хэндлера, вы должны сами перейти к следующему шагу работы с Долями SDK.

<p style="page-break-after: always;">&nbsp;</p>

# Секция 2: Сборка конфигурации Долями

Объект конфигурации собирается после нажатия юзером на кнопку "Оплатить Долями". Он собирается для того, чтобы позже быть переданным в координатор в следующей секции.

## `DolyamePaymentConfiguration`, корневой объект

Название|Тип|Описание
---|---|---
partner|`DolyamePaymentConfiguration.Partner`|Объект, описывающий данные о партнере, который интегрировал оплату Долями
order|`DolyamePaymentConfiguration.Order`|Объект, описывающий характеристики заказа, содержимое ниже.
customerInfo|`DolyamePaymentConfiguration.CustomerInfo`|Объект, описывающий известные данные о покупателе, содержимое ниже

<p style="page-break-after: always;">&nbsp;</p>

## `DolyamePaymentConfiguration.Partner`

Название|Тип|Описание
---|---|---
id|`String`|Уникальный идентификатор партнера, который будет выдан вам для интеграции. Если не выдали, свяжитесь с персональным менеджером Долями.
notificationUrl|`String`|Адрес, на который мы будем отправлять вебхук подтверждения результата оплаты. Если вы захотите зафиксировать боевой адрес на нашем бэке, чтобы не отправлять его здесь, обратитесь к персональному менеджеру Долями.
demoFlow|`Bool`|Понадобится при разработке. Этот флаг указывает, что данный запуск SDK должен быть через demoFlow. Подробности ниже, в секции "Тестирование интеграции".
showErrorScreenDebugInformation|`Bool`|Понадобится при разработке. Этот флаг включает визуальное отображение кодов ошибок на экранах ошибок. Рекомендуем включить на время разработки и тестирования.

<p style="page-break-after: always;">&nbsp;</p>

## `DolyamePaymentConfiguration.Order`

Название|Тип|Описание
---|---|---
id|`String`|Уникальный идентификатор заказа. Должен быть уникальным при каждом создании объекта конфигурации. В случае, если юзер попадает в флоу Долями для конкретного заказа во второй раз, нужно предоставить новый уникальный идентификатор.
amount|`Decimal`|Сумма для оплаты через сервис Долями. <br />Должно соблюдаться условие `amount + prepaidAmount == items.map { i in i.quantity * i.price }.reduce(0, +)`
prepaidAmount|`Decimal`|Сумма аванса, внесенного клиентом через другие способы оплаты. Например, оплата бонусами или подарочным сертификатом. <br />Должно соблюдаться условие `amount + prepaidAmount == items.map { i in i.quantity * i.price }.reduce(0, +)`
items|`[DolyamePaymentConfiguration.Order.Item]`|Массив с позициями в заказе
mcc|`Int`|MCC код с которым нужно совершить платеж. Указывайте значение 5311.

<p style="page-break-after: always;">&nbsp;</p>

## `DolyamePaymentConfiguration.Order.Item`
Название|Тип|Описание
---|---|---
name|`String`|Наименование товара
quantity|`Int`|Количество позиций данного наименования
price|`Decimal`|Цена одной позиции
sku|`String?`|SKU товара (уникальный идентификатор для каждого товара/артикул/первичный ключ). **Убедительная просьба** для товаров присылать SKU, т.к. из-за "кривых" названий (пробелы, пентаграммы и символы) могут возникнуть проблемы при возвратах клиентов.

<p style="page-break-after: always;">&nbsp;</p>

## `DolyamePaymentConfiguration.CustomerInfo`
Название|Тип|Описание
---|---|---
id|`String`|Уникальный идентификатор пользователя. При изменении учетной записи, мы ожидаем что будет приходить новый идентификатор, в том числе, если юзер был или стал не залогинен
firstName|`String?`|Имя покупателя. Обязательно передайте, если оно известно. Это необходимо для заполнения анкеты покупателя
lastName|`String?`|Фамилия покупателя. Обязательно передайте, если известна. Это необходимо для заполнения анкеты покупателя 
middleName|`String?`|Отчество покупателя. Обязательно передайте, если известно. Это необходимо для заполнения анкеты покупателя
phone|`String?`|Телефон клиента в формате +7. Если известен, **обязательно-обязательно** передайте. Пожалуйста! Это помогает нам в прохождении авторизации. Пример: `+79130010101`
birthday|`String?`|Дата рождения клиента в формате 28.05.1991. Обязательно передайте, если известна. Это необходимо для заполнения анкеты покупателя
email|`String?`|Email клиента. Обязательно передайте, если известен. Это необходимо для заполнения анкеты покупателя

<p style="page-break-after: always;">&nbsp;</p>

## Важные аспекты работы с объектом конфигурации

Идентификатор заказа `Order.id` должен быть уникальный при каждом запуске SDK. Если пользователь:
- попал во флоу Долями SDK чтобы оплатить заказ
- не оплатил заказ
- вернулся в ваше приложение
- захотел опять попасть во флоу Долями SDK
То:
- обязательно `Order.id` должен отличаться от того, с каким юзер уже заходил в Долями SDK.

При запуске флоу в SDK сохраняется полученный `CustomerInfo.id`. При последующих запусках SDK происходит
проверка `CustomerInfo.Id`:
- если был получен идентичный id, то авторизация в SDK сохраняется
- если был получен id, отличный от сохранённого при предыдущем запуске, то пользователь будет
разлогинен и должен будет заново пройти процесс авторизации

<p style="page-break-after: always;">&nbsp;</p>

# Секция 3: Запуск координатора флоу Долями

Имея собранный объект конфигурации, мы имеем все что нужно для того чтобы отправить пользователя во флоу Долями.

## Класс `DolyamePaymentCoordinator`

Этот класс является точкой входа и выхода для всего флоу.

### Параметры в конструкторе
Для того чтобы начать работу, необходимо создать координатор. Ниже представлен перечень параметров.

Название|Тип|Описание
---|---|---
configuration|`DolyamePaymentConfiguration`|Объект конфигурации, подробности в Секция 2
modalHostViewController|`UIViewController`|Вьюконтроллер, который уже находится на экране для того чтобы мы модально презентовали поверх него свой контент.

Вам необходимо хранить этот интанс координатора после создания. Если вы отпустите инстанс координатора, это нарушит работоспособность SDK.  
Также, мы не храним сильную ссылку на `UIViewController`, который вы нам передаете, во избежание retain-цикла.

<p style="page-break-after: always;">&nbsp;</p>

### Подписка на результат работы координатора

В конце своей работы, координатор уведомит вас о том, что он закончил работать.  Здесь, координатор уберет все экраны которые сам создавал для того, чтобы вернуть приложение в то состояние, в котором вы передали его SDK.

Публичный интерфейс конца работы флоу SDK выглядит следующим образом:

```swift
public enum DolyamePaymentCoordinatorResult {
    case success
    case failure
    case pending
    case dismissed
}

public class DolyamePaymentCoordinator {
    public var onFinish: ((DolyamePaymentCoordinatorResult) -> Void)?
}
```

Вам необходимо выставить `DolyamePaymentCoordinator.onFinish`. Внутри него вам **обязательно** нужно удалить координатор оттуда, куда вы его записывали.

Вот что обозначают значения этого результата:
Значение|Значение
---|---
`success`|Пользователь прошел флоу и успешно совершил платеж
`pending`|Пользователь прошел флоу и совершил платеж, но мы еще не получили подтверждение от эквайринга
`failure`|Пользователь наткнулся на ошибку, отказ скоринга, проблемы с авторизацией или интернетом
`dismissed`|Пользователь добровольно вышел из SDK, смахнул экраны или нажал на кнопку Закрыть

### Запуск координатора

Сейчас, когда координатор сконфигурирован, его можно запустить. Запуск приведет к показу экранов и запуску логики SDK.

Запуск производится посредством вызова метода `DolyamePaymentCoordinator.start`.
```swift
public class DolyamePaymentCoordinator {
    public func start()
}
```

<p style="page-break-after: always;">&nbsp;</p>

# Тестирование интеграции

## Неожиданные события

В процессе работы SDK Долями могут возникнуть непредвиденные ситуации. С точки зрения UX, мы берем на себя реагирование на них и правильный вывод пользователя из флоу SDK обратно в приложение партнера. Однако, для целей проверки интеграции, во время тестирования подключенного SDK, вам стоит подписаться на эти события, чтобы быть в курсе, если вы сделали что-то неправильно.

Хэндлер события вызыватся в результате работы с сервером, и не сразу. Когда вы только откроете SDK, хэндлер не будет вызван и вам нужно пойти дальше по флоу, чтобы проверить появление (или отсутствие) какого-то события. Хэндлер события может быть вызван на любой `DispatchQueue`, но это не страшно потому что вы не должны проводить никакие манипуляции с интерфейсом. Не забудьте про `weak self`.

Подписаться на события можно через `DolyamePaymentCoordinator.onUnexpectedEvent`:

```swift
public enum DolyameUnexpectedEvent {
    case lessThanRuble
    case haveSumDifference
    case haveItemsDifference
    case wrongPersonData
    case noPartnerForClient
}

public class DolyamePaymentCoordinator {
    public var onUnexpectedEvent: ((DolyameUnexpectedEvent) -> Void)?
}
```

Далее представлена таблица неожиданных событий.

<p style="page-break-after: always;">&nbsp;</p>

Неожиданное событие|Что значит?|Что делать?
---|---|---
`lessThanRuble`|Сумма заказа была меньше 1 рубля|Посмотреть, какие значения заказа были отправлены в конфигурацию SDK. Сумма в `item`'ов должна быть больше 1 рубля. `amount` тоже должен быть больше 1 рубля.
`haveSumDifference`|Сумма позиций в заказе не совпадает с общей суммой заказа. Данные заказа, которые вы предоставялете в конфигруации SDK должны удовлетворять уравнению `amount + prepaidAmount == items.map { i in i.quantity * i.price }.reduce(0, +)`.|Проверьте заказ, отправленный в SDK на сооветствие этому уравнению. Если с вашей стороны математика сходится, то пожалуйста, обратитесь с этим инцидентом к вашему персональному менеджеру в Долями.
`haveItemsDifference`|Позиции заказа отличаются от ранее полученных|Этот кейс никогда не должен приходить, потому что при каждом открытии SDK мы создаем новый заказ, не связанный с предыдущими. Если вы получили это событие, сообщите об этом менеджеру по интеграции Долями.
`wrongPersonData`|Переданные данные отличаются от хранимых|Этот кейс также не должен никогда случаться, но на случай если случится, сообщите об этом вашему персональному менеджеру по интеграции Долями.
`noPartnerForClient`|Ошибка доступа к SDK|Обратитесь к вашему персональному менеджеру по интеграции Долями.

<p style="page-break-after: always;">&nbsp;</p>

## Демо-заявка

Для того чтобы не тестировать на проде, SDK предлагает возможность проверки интеграции через демо заявку.

Отличия демо-заявки от нормального флоу:
- перед запуском основного флоу вам будет показан экран, на котором вы можете выбрать результат, чем флоу кончится
- не будет производиться работа с эквайрингом. При этом, подтверждение платежа будет приходить аналогично настоящему.

Есть пять вариантов окончания флоу: 
1. Отказ скоринга
1. Успешная оплата 1го платежа
1. Неуспешная оплата 1го платежа
1. Результат оплаты неизвестен, но в итоге оплата пройдет успешно
1. Результат оплаты неизвестен и в итоге неуспешная оплата

Шаги для запуска демо-заявки:
- в конфигурации `Partner` нужно указать `notificationUrl`, чтобы он указывал на ваше тестовое окружение. Если вы не укажете здесь `notificationUrl`, то вы не получите подтверждения платежа, даже если при интеграции вы давали дефолтный URL. Так как он не тестовый, а боевой.
- передайте в `demoFlow` значение `true`

<p style="page-break-after: always;">&nbsp;</p>

# Подключение Apple Pay

Основные принципы:
- SDK Долями поддерживает проведение платежей через Apple Pay. 
- В силу специфики работы инфраструктуры Apple Pay, мы не можем использовать наш собственный Merchant ID для проведения платежей с нашего Apple Developer аккаунта.
- Framework, который мы поставляем, будет встраиваться в ваши приложения и подписываться под вашим Apple Development Team'ом.
- Из-за этого Apple Pay Merchant ID должен быть создан на вашей стороне. 
- Если в вашем проекте уже используется Apple Pay и создан Merchant ID, обратите внимание, что мы будем пользоваться своим, отдельным Merchant ID для проведения платежей, который будет существовать параллельно вашему.

## Шаги по настройке Apple Pay в проекте и в Apple Developer Portal:

Вместе с SDK Долями вам будет предоставлен файл Certificate Signing Request. Этот файл будет использоваться для создания Payment Processing Certificate.

Для начала нужно создать новый Merchant ID:

- На портале Apple Developer, в меню слева "Certificates, IDs & Profiles" в секции "Identifiers" 
- Нажмите на "+", чтобы создать новый идентификатор, далее выберите тип идентификатора "Merchant ID"
- Поле Description: любой. Например "Dolyame SDK Merchant ID". 
- Поле Identifier: `merchant.ru.dolyame.DolyameSDK-*название вашего магазина*`. 
- Сообщите вашему персональному менеджеру в проекте Долями, какой Merchant ID вы создали.

Если с этим шагом будут сложности, обратитесь к вашему персональному менеджеру из проекта Долями.

Затем, создайте Payment Processing Certificate:

- на портале Apple Developer, в меню слева "Certificates, IDs & Profiles", в секции "Certificates"
- создайте новый сертификат, тип - "Apple Pay Payment Processing Certificate". 
- При создании вас попросят выбрать Merchant ID - выберите новосозданный Merchant ID из предыдущего пункта. 
- На вопрос "Will payments associated with this Merchant ID be processed exclusively in China mainland?" отвечайте "No."
- На запрос "Upload a Certificate Signing Request", загрузите Certificate Signing Request `.certSigningRequest` **который мы прислали вам**. Не создавайте свой, это критически важно!
- Скачайте получившийся `.cer` файл 
- Запакуйте его в .zip архив
- Передайте архив вашему персональному менеджеру в проекте Долями

После этого шага, Merchant ID создан и у нас есть сертификат для того чтобы по нему обрабатывать платежи ваших пользователей. После этого необходимо настроить ваш Xcode проект.

Как настроить ваш Xcode проект:

Если у вас еще не подключена Apple Pay Capability:

- В настройках Таргета вашего приложения, перейдите во вкладку Signing & Capabilities
- Нажмите на "+ Capability" чтобы добавить новую Capability
- Выберите Apple Pay
- Посмотрите, чтобы эта Capability создавалась для всех конфигураций (Debug, Release и все что у вас созданы дополнительно)
- Если у вас не был создан файл .entitlements и Xcode предложит его создать, соглашайтесь

Когда Apple Pay Capability подключена:

- добавьте Merchant ID, который вы создали, в список Merchant ID. Им сможет пользоваться ваше приложение.
- проверьте что Merchant ID успешно добавился в .entitlements файл

На этом шаге проект должен быть настроен и готов. 

Однако:
- Вы не передаете Merchant ID напрямую через конфигурацию SDK, вместо этого мы сами узнаем у наших серверов, какой Merchant ID нам использовать. Поэтому, заработает Apple Pay только после того как мы получим и обработаем Merchant ID и сертификат который вы нам пришлете
- Из-за этого, протестировать работоспособность и правильность настройки сразу не получится. После настройки свяжитесь с нами для проверки работоспособности оплаты через Apple Pay.
