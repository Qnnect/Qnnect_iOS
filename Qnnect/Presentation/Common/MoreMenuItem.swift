//
//  MoreMenuItem.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/22.
//

import UIKit

class MoreMenuItem: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(title: String) {
        super.init(frame: .zero)
        configureUI(title: title)
    }
    
    private func configureUI(title: String) {
        titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        setTitleColor(.GRAY01, for: .normal)
        setTitle(title, for: .normal)
        sizeToFit()
    }
}
