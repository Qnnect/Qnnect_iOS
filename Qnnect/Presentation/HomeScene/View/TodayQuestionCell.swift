//
//  ToDayQuestionCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/18.
//

import UIKit
import SnapKit
import Then

final class TodayQuestionCell: UICollectionViewCell {
    static let identifier = "TodayQuestionCell"
    
    private let groupNameLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.textColor = .GRAY02
        $0.textAlignment = .center
    }
    
    private let d_dayLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 10.0)
        $0.textColor = .BLACK_121212
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.BLACK_121212?.cgColor
        $0.layer.cornerRadius = $0.frame.height / 2.0
    }
    
    private let questionLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.numberOfLines = 0
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
            self.d_dayLabel,
            self.questionLabel
        ].forEach {
            self.contentView.addSubview($0)
        }
        
        self.groupNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(28.0)
            make.leading.trailing.equalToSuperview().inset(12.0)
        }
        
        self.d_dayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15.0)
            make.trailing.equalToSuperview().inset(21.0)
        }
        
        self.questionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(31.0)
            make.bottom.equalToSuperview().inset(48.0)
        }
    }
    
    func update() {
        
    }
}
