//
//  PageItemViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import UIKit
import SnapKit
import Then

final class PageItemViewController: BaseViewController {
    
    let textLabel = UILabel().then {
        $0.textColor = .GRAY01
        $0.font = .BM_JUA(size: 24.0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        self.view.addSubview(self.textLabel)
        
        self.textLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.7)
        }
    }
}
