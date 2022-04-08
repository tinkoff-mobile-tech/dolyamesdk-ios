import UIKit

class CheckoutItemView: UIView {

    var onEdit: (() -> Void)?

    private let titleLabel = UILabel()
    private let countLabel = UILabel()
    private let editButton = UIButton(type: .system)

    init() {
        super.init(frame: .zero)

        let containerView = UIView()
        if #available(iOS 13.0, *) {
            containerView.backgroundColor = .systemGroupedBackground
        } else {
            containerView.backgroundColor = UIColor(red: 242.0 / 255.0, green: 242.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0)
        }
        containerView.layer.cornerRadius = 12.0

        containerView.addSubview(titleLabel)
        titleLabel.text = "order.items"
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(12)
        }

        containerView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing)
        }

        containerView.addSubview(editButton)
        editButton.setTitle("Изменить", for: .normal)
        editButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(countLabel.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(12)
        }
        editButton.addTarget(self, action: #selector(onEditButtonTouched), for: .touchUpInside)

        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @objc func onEditButtonTouched() {
        onEdit?()
    }

    // MARK: - Internal

    func configure(with itemsCount: Int) {
        countLabel.text = "\(itemsCount)"
    }
}
