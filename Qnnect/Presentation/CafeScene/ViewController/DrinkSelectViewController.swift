//
//  SelectDrinkViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import UIKit
import SnapKit
import Then

final class DrinkSelectViewController: BottomSheetViewController {
    
    private let mainLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .GRAY01
        $0.text = "완성할 음료를 선택해주세요"
    }
    
    private let secondaryLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 12.0)
        $0.textColor = .GRAY03
        $0.numberOfLines = 2
        let paragraphStyle = Constants.paragraphStyle
        paragraphStyle.alignment = .left
        $0.attributedText =
        NSAttributedString(
            string: "1인1음료를 선택하고 답변을 통해 얻은 \n 포인트로 나의 음료를 완성해보세요!",
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
    }
    
    private let previousButton = UIButton().then {
        $0.setTitle("이전", for: .normal)
        $0.backgroundColor = .GRAY04
        $0.setTitleColor(.WHITE_FFFFFF, for: .normal)
        $0.layer.cornerRadius = Constants.bottomButtonCornerRadius
    }
    
    private let completionButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.backgroundColor = .p_brown
        $0.setTitleColor(.WHITE_FFFFFF, for: .normal)
        $0.layer.cornerRadius = Constants.bottomButtonCornerRadius
    }
    
    private let bottomButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 16.0
        $0.distribution = .fillEqually
    }
    static func create() -> DrinkSelectViewController {
        let vc = DrinkSelectViewController()
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        [
            self.previousButton,
            self.completionButton
        ].forEach {
            self.bottomButtonStackView.addArrangedSubview($0)
        }
        
        [
            self.mainLabel,
            self.secondaryLabel,
            self.bottomButtonStackView
        ].forEach {
            self.bottomSheetView.addSubview($0)
        }
        
        self.titleLabel.text = "음료 선택"
        
        self.mainLabel.snp.makeConstraints { make in
            make.top.equalTo(self.dismissButton.snp.bottom).offset(16.0)
            make.leading.trailing.equalToSuperview().inset(Constants.bottomSheetHorizontalMargin)
        }
        
        self.secondaryLabel.snp.makeConstraints { make in
            make.top.equalTo(self.mainLabel.snp.bottom).offset(5.0)
            make.leading.trailing.equalTo(self.mainLabel)
        }
        
        self.bottomButtonStackView.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(20.0)
            make.leading.trailing.equalToSuperview().inset(Constants.bottomSheetHorizontalMargin)
            make.height.equalTo(Constants.bottomButtonHeight)
        }
    }
    
    override func bind() {
        
    }
}
