//
//  MoreMenuBottomSheet.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/16.
//

import UIKit
import SnapKit
import Then

class CommentMoreMenuBottomSheet: BottomSheetViewController {
    
    private let modifyButton = UIButton().then {
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        $0.setTitleColor(.GRAY01, for: .normal)
        $0.setTitle("답변 수정", for: .normal)
        $0.sizeToFit()
    }
    
    private let deleteButton = UIButton().then {
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        $0.setTitleColor(.GRAY01, for: .normal)
        $0.setTitle("답변 삭제", for: .normal)
        $0.sizeToFit()
    }
    
    private let buttonStackView = UIStackView().then {
        $0.spacing = 30.0
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .leading
    }
    
    static func create() -> CommentMoreMenuBottomSheet {
        let view = CommentMoreMenuBottomSheet()
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        
        topPadding = 653.0
        dismissButton.isHidden = true
        [
            modifyButton,
            deleteButton
        ].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        bottomSheetView.addSubview(buttonStackView)
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.top.bottom.equalToSuperview().inset(44.0)
        }
    }
}
