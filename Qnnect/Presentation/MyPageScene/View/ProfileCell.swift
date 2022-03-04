//
//  profileCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/21.
//

import SnapKit
import Then
import UIKit

final class ProfileCell: UITableViewCell {
    static let identifier = "ProfileCell"
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = Constants.myPageProfileImageHeight / 2.0
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.profileImageBorder?.cgColor
        $0.clipsToBounds = true
    }
    
    private let nameLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 20.0)
        $0.textColor = .BLACK_121212
    }
    
    private let loginTypeLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 12.0)
        $0.textColor = .GRAY03
        $0.text = Constants.loginTypeText
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
            self.profileImageView,
            self.nameLabel,
            self.loginTypeLabel
        ].forEach {
            self.contentView.addSubview($0)
        }
        
        self.contentView.backgroundColor = .p_ivory
        
        self.profileImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(Constants.myPageProfileImageWidth)
            make.height.equalTo(Constants.myPageProfileImageHeight)
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.profileImageView.snp.trailing).offset(14.0)
            make.top.equalToSuperview().inset(5.0)
        }
        
        self.loginTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(1.0)
            make.leading.equalTo(self.nameLabel)
            make.trailing.equalToSuperview().inset(8.0)
        }
    }
    
    
    func update(with user: User) {
        self.nameLabel.text = user.name
        self.profileImageView.kf.setImage(
            with: URL(string:user.profileImage),
            placeholder: Constants.profileDefaultImage
        )
    }
}
