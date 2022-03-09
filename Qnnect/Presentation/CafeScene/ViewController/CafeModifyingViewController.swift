//
//  CafeModifyViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/09.
//

import UIKit
import SnapKit
import Then


final class CafeModifyingViewController: CafeInfoInputViewController {
    
    static func create() -> CafeModifyingViewController {
        let vc = CafeModifyingViewController()
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        self.titleLabel.text = "카페 수정하기"
    }
    
    override func bind() {
        super.bind()
    }
}
