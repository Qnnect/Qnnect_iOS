//
//  GroupQuestionCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/05.
//

import UIKit
import SnapKit
import Then

final class CafeToDayQuestionCell: UICollectionViewCell {
    static let identifier = "CafeToDayQuestionCell"
    
    private let createdDateLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 10.0)
        $0.textColor = .GRAY02
        $0.textAlignment = .center
    }
    
    private let d_dayLabel = BasePaddingLabel(padding: UIEdgeInsets(top: 7.0, left: 9.0, bottom: 7.0, right: 9.0)).then {
        $0.font = .IM_Hyemin(.bold, size: 10.0)
        $0.textColor = .BLACK_121212
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.BLACK_121212?.cgColor
        $0.layer.cornerRadius = 12.0
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.textColor = .BLACK_121212
        $0.textAlignment = .center
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
            self.createdDateLabel,
            self.titleLabel,
            self.d_dayLabel,
            self.questionLabel
        ].forEach {
            self.contentView.addSubview($0)
        }
        
        self.contentView.backgroundColor = .SECONDARY01
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.brownBorderColor?.cgColor
        self.contentView.layer.cornerRadius = Constants.homeCellCornerRadius
        
        self.createdDateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50.0)
            make.leading.trailing.equalToSuperview().inset(16.0)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.createdDateLabel.snp.bottom).offset(4.0)
            make.leading.trailing.equalToSuperview().inset(16.0)
        }
        
        self.d_dayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15.0)
            make.trailing.equalToSuperview().inset(21.0)
        }
        
        self.questionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(76.0)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(36.0)
            make.bottom.lessThanOrEqualToSuperview().inset(16.0)
        }
        
    }
    
    func update(with question: Question) {
        self.createdDateLabel.text = question.createdAt
        self.titleLabel.text = "\(question.questioner)의 질문"
        let paragraphStyle = Constants.paragraphStyle
        paragraphStyle.alignment = .center
        self.questionLabel.attributedText = NSAttributedString(
            string: question.qustion,
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        self.d_dayLabel.text = "D-\(question.daysLeft)"
    }
    
}
