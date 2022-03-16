//
//  CafeQuestionListCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/16.
//

import UIKit
import SnapKit
import Then

final class CafeQuestionListCell: UITableViewCell {
    static let identifier = "CafeQuestionListCell"
    
    private let titleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.textColor = .black
    }
    
    private let dateLabel = UILabel().then {
        $0.font = .Roboto(.regular, size: 12.0)
        $0.textColor = .GRAY04
        $0.textAlignment = .right
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    private func configureUI() {
        
        [
            titleLabel,
            dateLabel
        ].forEach {
            contentView.addSubview($0)
        }
        
        contentView.backgroundColor = .p_ivory
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20.0)
            make.trailing.equalToSuperview().inset(52.0)
            make.top.equalToSuperview().inset(25.0)
            make.bottom.equalToSuperview().inset(28.0)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(20.0)
        }
    }
    
    func update(with question: QuestionShortInfo) {
        titleLabel.text = question.content
        dateLabel.text = question.createdAt
    }
}
