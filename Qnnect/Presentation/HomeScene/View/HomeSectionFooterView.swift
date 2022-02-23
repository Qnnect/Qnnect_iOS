//
//  HomeSectionFooterView.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/21.
//

import UIKit
import SnapKit
import Then

final class HomeSectionFooterView: UICollectionReusableView {
    static let identifier = "HomeSectionFooterView"
    
    private(set) var addGroupButton = UIButton().then {
        $0.layer.borderWidth = 1.2
        $0.layer.borderColor = UIColor.brownBorderColor?.cgColor
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 12.0)
        $0.layer.cornerRadius = 18.0
        $0.setTitle("그룹 추가하기", for: .normal)
        $0.setTitleColor(.GRAY03, for: .normal)
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
        self.addSubview(self.addGroupButton)
        
        self.addGroupButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.bottomButtonHorizontalMargin - Constants.HomeCollectionViewHorizontalMargin)
            make.top.bottom.equalToSuperview()
        }
    }
}
