//
//  AllAgreementView.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/15.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxRelay

final class AllAgreementView: UIView {
    private let titleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.textColor = .GRAY01
    }
    
    private(set) var checkBox = UIButton().then {
        $0.setImage(UIImage(named: "NotCheckedBox"), for: .normal)
        $0.setImage(UIImage(named: "CheckedBox"), for: .selected)
    }
    
    var tapCheckBox: Observable<Bool>
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tapCheckBox = self.checkBox.rx.tap
            .map{
                [weak self] _ -> Bool in
                self?.checkBox.isSelected.toggle()
                return self?.checkBox.isSelected ?? false
            }

        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.tapCheckBox = self.checkBox.rx.tap
            .map{
                [weak self] _ -> Bool in
                self?.checkBox.isSelected.toggle()
                return self?.checkBox.isSelected ?? false
            }

        self.configureUI()
    }
    
    private func configureUI() {
        [
            self.titleLabel,
            self.checkBox
        ].forEach {
            self.addSubview($0)
        }
        
        self.titleLabel.text = "네, 모두 동의합니다."
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20.0)
            make.height.equalTo(34.0)
            make.centerY.equalToSuperview()
        }
            
        self.checkBox.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20.0)
            make.width.height.equalTo(24.0)
            make.centerY.equalTo(self.titleLabel)
        }
    }
    
    
    
}
