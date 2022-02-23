//
//  SelectDrinkViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import UIKit
import SnapKit
import Then

final class SelectDrinkViewController: BottomSheetViewController {
    
    private let mainLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .GRAY01
        $0.text = "완성할 음료를 선택해주세요"
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
    static func create() -> SelectDrinkViewController {
        let vc = SelectDrinkViewController()
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
            self.bottomButtonStackView
        ].forEach {
            self.bottomSheetView.addSubview($0)
        }
        
        //self.view.backgroundColor = .black.withAlphaComponent(0.5)
        
        self.mainLabel.snp.makeConstraints { make in
            make.top.equalTo(self.dismissButton.snp.bottom).offset(16.0)
            make.leading.trailing.equalToSuperview().inset(Constants.bottomSheetHorizontalMargin)
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
