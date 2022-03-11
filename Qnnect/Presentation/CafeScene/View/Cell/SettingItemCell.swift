//
//  SettingItemCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/07.
//

import UIKit
import Then
import SnapKit

final class SettingItemCell: UITableViewCell {
    static let identifier = "SettingItemCell"
    
    private let mainLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .GRAY01
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
        self.contentView.addSubview(self.mainLabel)
        self.contentView.backgroundColor = .p_ivory
        
        self.mainLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(21.0)
            make.top.bottom.equalToSuperview().inset(15.0)
        }
    }
    
    func update(with title: String) {
        self.mainLabel.text = title
    }
}
