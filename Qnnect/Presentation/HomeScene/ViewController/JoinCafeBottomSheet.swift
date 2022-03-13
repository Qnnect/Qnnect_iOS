//
//  CafeJoinBottomSheet.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/13.
//

import UIKit
import SnapKit
import Then

final class JoinCafeBottomSheet: BottomSheetViewController {
    
    private let mainLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.text = "초대코드를 입력해주세요"
    }
    
    private let inputTextField = UITextField().then {
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.textColor = .GRAY01
        $0.placeholder = "초대코드"
    }
    
    private let completionButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.WHITE_FFFFFF, for: .normal)
        $0.backgroundColor = .p_brown
        $0.layer.cornerRadius = 10.0
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.BLACK_121212?.cgColor
    }
    
    static func create() -> JoinCafeBottomSheet {
        let bottomSheet = JoinCafeBottomSheet()
        return bottomSheet
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputTextField.drawUnderLine()
    }
    
    override func configureUI() {
        super.configureUI()
        
        self.topPadding = 485.0
        self.titleLabel.text = "카페 참여하기"
        
        [
            mainLabel,
            inputTextField,
            completionButton
        ].forEach {
            bottomSheetView.addSubview($0)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.top.equalTo(dismissButton.snp.bottom).offset(20.0)
        }
        
        inputTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.top.equalTo(mainLabel.snp.bottom).offset(20.0)
        }
        
        completionButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.bottomSheetHorizontalMargin)
            make.height.equalTo(Constants.bottomButtonHeight)
            make.top.equalTo(inputTextField.snp.bottom).offset(67.0)
            
        }
    }
    
    override func bind() {
        super.bind()
    }
    
}
