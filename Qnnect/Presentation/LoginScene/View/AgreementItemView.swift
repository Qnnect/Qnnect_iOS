//
//  AgreementLabel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/15.
//

import UIKit
import SnapKit
import Then

enum AgreementType: String {
    case essential = "필수"
    case choice = "선택"
    case all
}
final class AgreementItemView: UIView {
    private let titleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.textColor = .GRAY01
    }
    
    private let disclosureIndicatorImageView = UIImageView().then {
        $0.image = UIImage(named: "DisclosureIndicator")
        $0.contentMode = .scaleAspectFit
    }
    
    private let checkBox = UIImageView().then {
        $0.image = UIImage(named: "NotCheckedBox")
        $0.contentMode = .scaleAspectFit
    }

    private let type: AgreementType
    
    init(type: AgreementType) {
        self.type = type
        super.init(frame: .zero)
        self.configureUI()
    }
    override init(frame: CGRect) {
        self.type = .choice
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        self.type = .choice
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
            make.width.height.equalTo(24.0)
            make.centerY.equalTo(self.titleLabel)
        }
    }
    
    func update(with title: String) {
        if self.type == .all {
            self.disclosureIndicatorImageView.isHidden = true
            self.titleLabel.text = title
        } else {
            self.titleLabel.text = title + " (\(self.type.rawValue))"
        }
        
    }
}

