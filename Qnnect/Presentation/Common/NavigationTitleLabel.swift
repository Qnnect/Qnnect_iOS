//
//  NavigationTitleLabel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/17.
//

import UIKit

final class NavigationTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(title: String) {
        super.init(frame: .zero)
        configureUI()
        text = title
    }
    
    private func configureUI() {
        font = .IM_Hyemin(.bold, size: 16.0)
        textColor = .GRAY01
    }
}
