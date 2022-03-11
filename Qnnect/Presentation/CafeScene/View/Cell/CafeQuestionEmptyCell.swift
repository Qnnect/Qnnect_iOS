//
//  CafeDrinksEmptyCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/08.
//

import UIKit
import SnapKit
import Then

final class CafeQuestionEmptyCell: UICollectionViewCell {
    static let idendifier = "CafeQuestionEmptyCell"
    
    private let mainLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 12.0)
        $0.textColor = .GRAY03
        $0.text = "아직 질문이 없습니다."
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
        self.contentView.addSubview(self.mainLabel)
        
        self.contentView.backgroundColor = .SECONDARY01
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.brownBorderColor?.cgColor
        self.contentView.layer.cornerRadius = Constants.homeCellCornerRadius
        
        self.mainLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
}
