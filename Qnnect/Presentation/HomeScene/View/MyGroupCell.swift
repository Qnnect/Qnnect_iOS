//
//  MyGroupCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/18.
//

import UIKit
import Then
import SnapKit

final class MyGroupCell: UICollectionViewCell {
    static let identifier = "MyGroupCell"
    
    private let groupNameLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .BLACK_121212
        $0.numberOfLines = 0
    }
    
    private let createdDateLabel = UILabel().then {
        $0.font = .IM_Hyemin(.regular, size: 12.0)
        $0.textColor = .GRAY01
    }
    
    private let headcountLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 12.0)
        $0.textColor = .BLACK_121212
    }
    
    private func configureUI() {
        
        [
            self.groupNameLabel,
            self.createdDateLabel,
            self.headcountLabel
        ].forEach {
            self.contentView.addSubview($0)
        }
        
        self.groupNameLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(19.0)
        }
        
        self.createdDateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.groupNameLabel.snp.bottom).offset(4.0)
            make.leading.trailing.equalTo(self.groupNameLabel)
        }
        
        self.headcountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(18.0)
            make.bottom.equalToSuperview().inset(15.0)
        }
    }
    
    func update() {
        
    }
}
