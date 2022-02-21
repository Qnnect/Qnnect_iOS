//
//  AgreementLabel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/15.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxRelay

final class AgreementItemView: UIView {
    private let titleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.textColor = .GRAY01
    }
    
    private let disclosureIndicatorImageView = UIImageView().then {
        $0.image = UIImage(named: "DisclosureIndicator")
        $0.contentMode = .scaleAspectFit
    }
    
    let checkBox = UIButton().then {
        $0.setImage(UIImage(named: "NotCheckedBox"), for: .normal)
        $0.setImage(UIImage(named: "CheckedBox"), for: .selected)
    }
    
    private(set) var type: Term
    
    init(type: Term) {
        self.type = type
        super.init(frame: .zero)
        self.configureUI()
    }
    override init(frame: CGRect) {
        self.type = .personal // 쓰레기 값
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        self.type = .personal // 쓰레기 값
        super.init(coder: coder)
        self.configureUI()
    }
    
    private func configureUI() {
        [
            self.titleLabel,
            self.disclosureIndicatorImageView,
            self.checkBox
        ].forEach {
            self.addSubview($0)
        }
        
        self.titleLabel.text = self.type.title
      
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20.0)
            make.height.equalTo(34.0)
            make.centerY.equalToSuperview()
        }
        
        self.disclosureIndicatorImageView.snp.makeConstraints { make in
            make.leading.equalTo(self.titleLabel.snp.trailing).offset(2.0)
            make.centerY.equalTo(self.titleLabel)
            make.width.equalTo(24.0)
            make.height.equalTo(24.0)
        }
        
        self.checkBox.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20.0)
            make.width.height.equalTo(48.0)
            make.centerY.equalTo(self.titleLabel)
        }
    }
    
}

