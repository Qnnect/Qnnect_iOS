//
//  CafeDrinksSectionBackgroundView.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/06.
//

import UIKit
import SnapKit
import Then

final class CafeDrinksSectionDecorationView: UICollectionReusableView {
    static let identifier = "CafeDrinksSectionBackgroundView"
    
    private let insetView = UIView().then {
        $0.layer.cornerRadius = 16.0
        $0.layer.borderWidth = 1.0
        $0.backgroundColor = .secondaryBackground
        $0.layer.borderColor = UIColor.groupDrinksBorder?.cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    private func configureUI() {
      
        self.addSubview(self.insetView)
        
        self.insetView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.top.bottom.equalToSuperview()
        }
    }
}
