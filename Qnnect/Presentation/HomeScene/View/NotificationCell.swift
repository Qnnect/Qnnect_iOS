//
//  NotificationCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/29.
//

import UIKit
import SnapKit
import Then

final class NotificationCell: UITableViewCell {
    static let identifier = "NotificationCell"
    
    private let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let cafeNameLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 12.0)
        $0.textColor = .secondaryBorder
    }
    private let titleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.textColor = .black
        $0.numberOfLines = 2
    }
    
    private let dateLabel = UILabel().then {
        $0.font = .Roboto(.regular, size: 12.0)
        $0.textColor = .GRAY04
        $0.textAlignment = .right
    }
    
    private let paragraphStyle = Constants.paragraphStyle.with {
        $0.alignment = .left
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
            iconImageView,
            cafeNameLabel,
            titleLabel,
            dateLabel
        ].forEach {
            contentView.addSubview($0)
        }
        contentView.backgroundColor = .p_ivory
        selectionStyle = .none
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24.0)
            make.centerY.equalToSuperview()
        }
        iconImageView.setContentHuggingPriority(.required, for: .horizontal)
        
        cafeNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(10.0)
            make.trailing.equalToSuperview().inset(20.0)
            make.top.equalToSuperview().inset(21.0)
        }
        cafeNameLabel.setContentHuggingPriority(.required, for: .vertical)
        
        titleLabel.snp.makeConstraints { make in
            make.trailing.equalTo(cafeNameLabel)
            make.leading.equalTo(cafeNameLabel)
            make.top.equalTo(cafeNameLabel.snp.bottom).offset(3.0)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(22.0)
            make.top.equalTo(titleLabel.snp.bottom).offset(4.0)
            make.bottom.equalToSuperview()
        }
        dateLabel.setContentHuggingPriority(.required, for: .vertical)
    }
    
    func update(with notification: NotificationInfo) {
        
        cafeNameLabel.text = notification.groupName
        dateLabel.text = notification.createdAt
        titleLabel.attributedText = NSMutableAttributedString(
            string: notification.content,
            attributes: [NSAttributedString.Key.paragraphStyle: Constants.paragraphStyle]
        )
        
        if notification.userRead {
            cafeNameLabel.textColor = .GRAY03
            titleLabel.textColor = .GRAY03
            iconImageView.image = notification.type.readIcon
        } else {
            cafeNameLabel.textColor = .BLACK_121212
            titleLabel.textColor = .BLACK_121212
            iconImageView.image = notification.type.icon
        }
    }
}
