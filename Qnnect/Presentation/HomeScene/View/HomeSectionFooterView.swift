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
    
    private(set) var addCafeButton = UIButton().then {
        $0.layer.borderWidth = 1.2
        $0.layer.borderColor = UIColor.brownBorderColor?.cgColor
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 12.0)
        $0.layer.cornerRadius = 18.0
        $0.setTitle("카페 만들기", for: .normal)
        $0.setTitleColor(.GRAY03, for: .normal)
    }
    
    private(set) var joinCafeButton = UIButton().then {
        $0.layer.borderWidth = 1.2
        $0.layer.borderColor = UIColor.brownBorderColor?.cgColor
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 12.0)
        $0.layer.cornerRadius = 18.0
        $0.setTitle("카페 참여하기", for: .normal)
        $0.setTitleColor(.GRAY03, for: .normal)
    }
    
    private let buttonStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.spacing = 16.0
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
        
        [
            addCafeButton,
            joinCafeButton
        ].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        addSubview(buttonStackView)
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.bottomButtonHorizontalMargin)
            make.top.bottom.equalToSuperview()
        }
        
       
    }
}
