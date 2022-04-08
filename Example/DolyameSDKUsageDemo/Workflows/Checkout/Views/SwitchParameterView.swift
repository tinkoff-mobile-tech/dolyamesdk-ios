//
//  SwitchParameterView.swift
//  DolyameSDKUsageDemo
//
//  Created by a.tonkhonoev on 02.12.2021.
//

import UIKit

class SwitchParameterView: UIView {
    let label = UILabel()
    let switcher = UISwitch()

    init() {
        super.init(frame: .zero)

        label.font = .systemFont(ofSize: 13, weight: .light)
        addSubview(label)
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(16)
        }

        addSubview(switcher)
        switcher.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalTo(label.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(8)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
