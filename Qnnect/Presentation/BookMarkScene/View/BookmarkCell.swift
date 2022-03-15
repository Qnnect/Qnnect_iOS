//
//  bookmarkCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/17.
//

import UIKit
import SnapKit
import Then

final class BookmarkCell: UITableViewCell {
    static let identifier: String = "BookmarkCell"
    
    private let cafeNameLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 12.0)
        $0.textColor = .secondaryBorder
    }
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
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    private func configureUI() {
        
        [
            cafeNameLabel,
            titleLabel,
            dateLabel
        ].forEach {
            contentView.addSubview($0)
        }
        
        contentView.backgroundColor = .p_ivory
        
        cafeNameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(25.0)
            make.top.equalToSuperview().inset(21.0)
        }
        cafeNameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(cafeNameLabel)
            make.top.equalTo(cafeNameLabel.snp.bottom).offset(3.0)
        }
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        dateLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(22.0)
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    func update(with question: ScrapedQuestion) {
        dateLabel.text = question.createdAt
        titleLabel.text = question.question
        cafeNameLabel.text = question.cafeTitle
    }
}
