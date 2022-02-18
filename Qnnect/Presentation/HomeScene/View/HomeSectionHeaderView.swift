//
//  HomeSectionHeader.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/18.
//

import UIKit
import Then

final class HomeSectionHeaderView: UICollectionReusableView {
    
    static let identifier = "HomeSectionHeaderView"
    
    private let titleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 18.0)
        $0.textColor = .BLACK_121212
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
        self.addSubview(titleLabel)
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(19.0)
        }
    }
    
    func update(with title: String) {
        self.titleLabel.text = title
    }
}
