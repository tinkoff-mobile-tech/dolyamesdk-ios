import DolyameSDK
import UIKit

class CheckoutCoordinator {
    let modalHostController: UIViewController

    var onFinish: (() -> Void)?

    var dolyamePaymentCoordinator: DolyamePaymentCoordinator?
    private var itemsCoordinator: ItemsListCoordinator?

    init(modalHostController: UIViewController) {
        self.modalHostController = modalHostController
    }

    func start() {
        let checkoutPresenter = CheckoutPresenter()
        let checkoutViewController = CheckoutViewController(presenter: checkoutPresenter,
                                                            inputValueValidator: InputValueValidator())
        checkoutPresenter.view = checkoutViewController

        checkoutPresenter.navigation.onItemsEditTouched = { [weak self, weak checkoutPresenter] items in
            self?.startItemsFlow(items: items) { newItems in
                checkoutPresenter?.updateModel(with: newItems)
            }
        }

        checkoutPresenter.navigation.onPayButtonTouched = { [weak self] model in
            guard let self = self else { return }

            let items = model.orderItems.map {
                DolyamePaymentConfiguration.Order.Item(name: $0.name,
                                                       quantity: $0.quantity,
                                                       price: $0.price,
                                                       sku: $0.sku)
            }
            let orderData = DolyamePaymentConfiguration.Order(id: model.orderId,
                                                              amount: model.orderAmount,
                                                              prepaidAmount: model.orderPrepaidAmount,
                                                              items: items,
                                                              mcc: model.orderMcc)
            let customerData = DolyamePaymentConfiguration.Customer(id: model.clientInfoId,
                                                                    firstName: model.clientInfoFirstName,
                                                                    lastName: model.clientInfoLastName,
                                                                    middleName: model.clientInfoMiddleName,
                                                                    phone: model.clientInfoPhone,
                                                                    birthday: model.clientInfoBirthday,
                                                                    email: model.clientInfoEmail)

            let partner = DolyamePaymentConfiguration.Partner(id: "bnpl-test-app",
                                                              notificationUrl: model.notificationUrl,
                                                              demoFlow: model.isDemoFlow)

            let dolyamePaymentConfig = DolyamePaymentConfiguration(partner: partner,
                                                                   order: orderData,
                                                                   customer: customerData)

            let dolyamePaymentCoordinator = DolyamePaymentCoordinator(configuration: dolyamePaymentConfig,
                                                                      modalHostController: checkoutViewController)

            self.dolyamePaymentCoordinator = dolyamePaymentCoordinator

            dolyamePaymentCoordinator.onFinish = { [weak checkoutViewController] dolyameResult in
                let alert = UIAlertController(title: "Dolyame SDK Finished",
                                              message: "Result = \(dolyameResult.readableName)",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Alright", style: .default, handler: nil))

                checkoutViewController?.present(alert, animated: true)
            }

            dolyamePaymentCoordinator.start()
        }

        let itemsCoordinator = ItemsListCoordinator(modalHostController: checkoutViewController)
        self.itemsCoordinator = itemsCoordinator

        modalHostController.present(checkoutViewController, animated: true)
    }

    // MARK: - Private

    private func startItemsFlow(items: [CheckoutItemModel],
                                onSuccess: @escaping ([CheckoutItemModel]) -> Void) {
        guard let itemsCoordinator = itemsCoordinator else {
            return
        }
        itemsCoordinator.onNewItemsAdded = { model in
            onSuccess(model)
        }
        itemsCoordinator.items = items
        itemsCoordinator.start()
    }
}

extension DolyamePaymentCoordinatorResult {
    var readableName: String {
        switch self {
        case .failure:
            return "failure"
        case .pending:
            return "pending"
        case .success:
            return "success"
        case .dismissed:
            return "dismissed"
        }
    }
}
