//
//  PointBar.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/16.
//

import UIKit
import Then
import SnapKit

final class PointBar: UIView {
    private let pointImageView = UIImageView().then {
        $0.image = Constants.pointImage
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 1.25
    }
    
    private let pointLabel = UILabel().then {
        $0.text = "500P" //TODO: 서버에서 주는 포인트값으로 변경
        $0.font = .BM_JUA(size: 18.0)
        $0.textColor = .BLACK_121212
    }
    
    private let alarmImageView = UIImageView().then {
        $0.image = Constants.notificationIcon
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    private func configureUI() {
        [
            self.pointImageView,
            self.pointLabel,
            self.alarmImageView
        ].forEach {
            self.addSubview($0)
        }
        
        self.pointImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24.0)
            make.top.equalToSuperview().inset(9.44)
            make.bottom.equalToSuperview().inset(7.99)
        }
        
        self.pointLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.pointImageView.snp.trailing).offset(8.0)
            make.top.bottom.equalToSuperview().inset(9.0)
        }
        
        self.alarmImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20.0)
            make.top.bottom.equalToSuperview().inset(12.0)
        }
    }
}
