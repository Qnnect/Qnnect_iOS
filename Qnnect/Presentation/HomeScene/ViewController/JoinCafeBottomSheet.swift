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
    
    static func create() -> JoinCafeBottomSheet {
        let bottomSheet = JoinCafeBottomSheet()
        return bottomSheet
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        
        self.topPadding = 485.0
        self.titleLabel.text = "카페 참여하기"
    }
    
    override func bind() {
        super.bind()
    }
    
}
