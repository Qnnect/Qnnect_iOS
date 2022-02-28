//
//  MyGroupCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/18.
//

import UIKit
import Then
import SnapKit

final class MyCafeCell: UICollectionViewCell {
    static let identifier = "MyGroupCell"
    
    private let groupNameLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .BLACK_121212
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
    }
    
    private let createdDateLabel = UILabel().then {
        $0.font = .IM_Hyemin(.regular, size: 12.0)
        $0.textColor = .GRAY01
    }
    
    private let headCountLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 12.0)
        $0.textColor = .BLACK_121212
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
            self.groupNameLabel,
            self.createdDateLabel,
            self.headCountLabel
        ].forEach {
            self.contentView.addSubview($0)
        }
        
        self.contentView.backgroundColor = .groupPink
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.brownBorderColor?.cgColor
        self.layer.cornerRadius = Constants.homeCellCornerRadius
        self.clipsToBounds = true
        
        self.groupNameLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(19.0)
        }
        
        self.createdDateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.groupNameLabel.snp.bottom).offset(4.0)
            make.leading.trailing.equalTo(self.groupNameLabel)
        }
        
        self.headCountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(18.0)
            make.bottom.equalToSuperview().inset(15.0)
        }
    }
    
    func update(with group: Group) {
        self.groupNameLabel.text = group.name
        self.createdDateLabel.text = group.createdDay
        self.headCountLabel.text = "\(group.headCount)명"
    }
}
