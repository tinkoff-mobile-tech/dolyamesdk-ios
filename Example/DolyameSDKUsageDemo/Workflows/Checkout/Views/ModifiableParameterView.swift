import UIKit

class ModifiableParameterView: UIView {
    let label = UILabel()
    let textField = UITextField()

    init() {
        super.init(frame: .zero)

        label.font = .systemFont(ofSize: 13, weight: .light)
        addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
