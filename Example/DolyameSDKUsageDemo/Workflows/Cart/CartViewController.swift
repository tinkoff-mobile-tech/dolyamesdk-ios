import UIKit

class CartViewController: UIViewController {
    let titleLabel = UILabel()
    let checkoutButton = UIButton(type: .system)

    var onCheckoutRequested: (() -> Void)?

    init() {
        super.init(nibName: nil, bundle: nil)

        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }

        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Your Cart, %username%"

        view.addSubview(checkoutButton)
        checkoutButton.translatesAutoresizingMaskIntoConstraints = false
        checkoutButton.setTitle("Proceed to checkout", for: .normal)
        checkoutButton.addTarget(self, action: #selector(tapCheckout), for: .touchUpInside)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),

            checkoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        onCheckoutRequested?()
    }

    @objc func tapCheckout() {
        onCheckoutRequested?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
