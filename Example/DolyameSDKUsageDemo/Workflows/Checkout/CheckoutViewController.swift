import DolyameSDK
import UIKit

class CheckoutViewController: UIViewController {

    private let presenter: ICheckoutViewOutput
    private let inputValueValidator: IInputValueValidator

    // MARK: - Views

    let scrollView = UIScrollView()
    let scrollContentView = UIView()
    let stackView = UIStackView()
    let payWithDolyameButton = DolyamePaymentButton()

    let demoFlowParamView = SwitchParameterView()

    let notificationUrlParamView = ModifiableParameterView()

    let orderIdParamView = ModifiableParameterView()
    let orderAmountParamView = ModifiableParameterView()
    let orderPrepaidAmountParamView = ModifiableParameterView()
    let orderItemsView = CheckoutItemView()
    let orderMccParamView = ModifiableParameterView()

    let clientInfoIdParamView = ModifiableParameterView()
    let clientInfoFirstNameParamView = ModifiableParameterView()
    let clientInfoLastNameParamView = ModifiableParameterView()
    let clientInfoMiddleNameParamView = ModifiableParameterView()
    let clientInfoPhoneParamView = ModifiableParameterView()
    let clientInfoBirthdayParamView = ModifiableParameterView()
    let clientInfoEmailParamView = ModifiableParameterView()

    // MARK: - Private

    var orderItemsCount: Int = 0

    // MARK: - Initializer & Deinitializer

    init(presenter: ICheckoutViewOutput,
         inputValueValidator: IInputValueValidator) {
        self.presenter = presenter
        self.inputValueValidator = inputValueValidator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - View's lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOutsideResponders))
        view.addGestureRecognizer(tapGestureRecognizer)

        setup()
        orderItemsView.configure(with: orderItemsCount)
        orderItemsView.onEdit = { [weak self] in
            self?.presenter.onItemsEdit()
        }
        presenter.onViewDidLoad()
    }

    // MARK: - Internal

    func startDolyamePayment() {
        let notificationUrl = inputValueValidator.replaceEmptyStringWithNil(textField: notificationUrlParamView.textField)

        let orderId = inputValueValidator.validateStringValue(textField: orderIdParamView.textField)
        let orderAmount = inputValueValidator.validateDecimalValue(textField: orderAmountParamView.textField)
        let orderPrepaidAmount = inputValueValidator.validateDecimalValue(textField: orderPrepaidAmountParamView.textField)
        let orderMcc = inputValueValidator.validateIntValue(textField: orderMccParamView.textField)
        let clientInfoId = inputValueValidator.validateStringValue(textField: clientInfoIdParamView.textField)

        let clientInfoFirstName = inputValueValidator.replaceEmptyStringWithNil(textField: clientInfoFirstNameParamView.textField)
        let clientInfoLastName = inputValueValidator.replaceEmptyStringWithNil(textField: clientInfoLastNameParamView.textField)
        let clientInfoMiddleName = inputValueValidator.replaceEmptyStringWithNil(textField: clientInfoMiddleNameParamView.textField)
        let clientInfoPhone = inputValueValidator.replaceEmptyStringWithNil(textField: clientInfoPhoneParamView.textField)
        let clientInfoBirthday = inputValueValidator.replaceEmptyStringWithNil(textField: clientInfoBirthdayParamView.textField)
        let clientInfoEmail = inputValueValidator.replaceEmptyStringWithNil(textField: clientInfoEmailParamView.textField)

        if let orderId = orderId,
            let orderAmount = orderAmount,
            let orderPrepaidAmount = orderPrepaidAmount,
            let orderMcc = orderMcc,
            let clientInfoId = clientInfoId {
            let inputData = CheckoutInputData(isDemoFlow: demoFlowParamView.switcher.isOn,
                                              notificationUrl: notificationUrl,
                                              orderId: orderId,
                                              orderAmount: orderAmount,
                                              orderPrepaidAmount: orderPrepaidAmount,
                                              orderMcc: orderMcc,
                                              clientInfoId: clientInfoId,
                                              clientInfoFirstName: clientInfoFirstName,
                                              clientInfoLastName: clientInfoLastName,
                                              clientInfoMiddleName: clientInfoMiddleName,
                                              clientInfoPhone: clientInfoPhone,
                                              clientInfoBirthday: clientInfoBirthday,
                                              clientInfoEmail: clientInfoEmail)
            presenter.onPayment(with: inputData)
        }
    }

    // MARK: - Actions

    @objc func tapOutsideResponders() {
        view.endEditing(true)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        keyboardFrame = view.convert(keyboardFrame, from: nil)

        var contentInset: UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }

    // MARK: Private

    private func setup() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.trailing.equalToSuperview()
        }

        scrollView.addSubview(scrollContentView)
        scrollContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.snp.width)
        }

        scrollContentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(12)
        }

        stackView.axis = .vertical
        stackView.spacing = 2

        let flowLabel = UILabel()
        flowLabel.text = "Flow"
        stackView.addArrangedSubview(flowLabel)

        stackView.addArrangedSubview(demoFlowParamView)
        demoFlowParamView.label.text = "Demo flow"
        demoFlowParamView.switcher.setOn(false, animated: false)

        let partnerLabel = UILabel()
        partnerLabel.text = "Partner"
        stackView.addArrangedSubview(partnerLabel)
        stackView.addArrangedSubview(notificationUrlParamView)
        notificationUrlParamView.label.text = "Notification url"

        let orderLabel = UILabel()
        orderLabel.text = "Order"
        stackView.addArrangedSubview(orderLabel)
        stackView.addArrangedSubview(orderIdParamView)
        orderIdParamView.label.text = "order.id"
        stackView.addArrangedSubview(orderAmountParamView)
        orderAmountParamView.label.text = "order.amount"
        orderAmountParamView.textField.keyboardType = .numberPad
        stackView.addArrangedSubview(orderPrepaidAmountParamView)
        orderPrepaidAmountParamView.label.text = "order.prepared_amount"
        stackView.addArrangedSubview(orderMccParamView)
        orderMccParamView.label.text = "order.mcc"

        stackView.addArrangedSubview(orderItemsView)

        let clientInfoLabel = UILabel()
        clientInfoLabel.text = "Client_info"
        stackView.addArrangedSubview(clientInfoLabel)
        stackView.addArrangedSubview(clientInfoIdParamView)
        clientInfoIdParamView.label.text = "client_info.id"
        stackView.addArrangedSubview(clientInfoFirstNameParamView)
        clientInfoFirstNameParamView.label.text = "client_info.first_name"
        stackView.addArrangedSubview(clientInfoLastNameParamView)
        clientInfoLastNameParamView.label.text = "client_info.last_name"
        stackView.addArrangedSubview(clientInfoMiddleNameParamView)
        clientInfoMiddleNameParamView.label.text = "client_info.middle_name"
        stackView.addArrangedSubview(clientInfoPhoneParamView)
        clientInfoPhoneParamView.label.text = "client_info.phone(+7xxxxxxxxxx)"
        stackView.addArrangedSubview(clientInfoBirthdayParamView)
        clientInfoBirthdayParamView.label.text = "client_info.birthday(dd.mm.yyyy)"
        stackView.addArrangedSubview(clientInfoEmailParamView)
        clientInfoEmailParamView.label.text = "client_info.email"

        payWithDolyameButton.applyStyle(.sharpCorners)
        view.addSubview(payWithDolyameButton)
        payWithDolyameButton.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(24)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        payWithDolyameButton.onButtonPressed = { [weak self] in
            guard let self = self else { return }
            self.startDolyamePayment()
        }
    }
}

extension CheckoutViewController: ICheckoutViewInput {

    func configure(with inputData: CheckoutInputData) {
        demoFlowParamView.switcher.setOn(inputData.isDemoFlow, animated: false)
        orderIdParamView.textField.text = inputData.orderId
        orderAmountParamView.textField.text = "\(inputData.orderAmount)"
        orderPrepaidAmountParamView.textField.text = "\(inputData.orderPrepaidAmount)"
        orderMccParamView.textField.text = "\(inputData.orderMcc)"

        clientInfoIdParamView.textField.text = inputData.clientInfoId
        clientInfoFirstNameParamView.textField.text = inputData.clientInfoFirstName
        clientInfoLastNameParamView.textField.text = inputData.clientInfoLastName
        clientInfoMiddleNameParamView.textField.text = inputData.clientInfoMiddleName
        clientInfoPhoneParamView.textField.text = inputData.clientInfoPhone
        clientInfoBirthdayParamView.textField.text = inputData.clientInfoBirthday
        clientInfoEmailParamView.textField.text = inputData.clientInfoEmail
    }

    func update(itemsCount: Int) {
        orderItemsCount = itemsCount
        orderItemsView.configure(with: orderItemsCount)
    }
}
