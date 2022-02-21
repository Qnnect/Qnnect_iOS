//
//  MyPageItemCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/21.
//

import UIKit
import SnapKit
import Then

final class MyPageItemCell: UITableViewCell {
    static let identifier = "MyPageItemCell"
    
    private let titleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.textColor = .black
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
        self.contentView.addSubview(self.titleLabel)
        self.contentView.backgroundColor = .p_ivory
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(14.0)
        }
    }
    
    func update(with myPageItem: MyPageItem) {
        self.titleLabel.text = myPageItem.title
    }
}
