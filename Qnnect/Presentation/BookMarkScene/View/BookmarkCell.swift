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
            self.titleLabel,
            self.dateLabel
        ].forEach {
            self.contentView.addSubview($0)
        }
        
        self.contentView.backgroundColor = .p_ivory
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(25.0)
        }
        
        self.dateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    func update(with question: ScrapedQuestion) {
        self.dateLabel.text = question.createdAt
        self.titleLabel.text = question.question
    }
}
