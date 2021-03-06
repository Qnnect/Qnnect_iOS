//
//  TitleCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/18.
//

import UIKit
import SnapKit
import Then

final class TitleCell: UICollectionViewCell {
    static let identifier = "TitleCell"
    
    private let profileImageView = CircleImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 20.0)
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
            self.profileImageView,
            self.titleLabel
        ].forEach {
            self.contentView.addSubview($0)
        }
            
        self.titleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(self.profileImageView)
        }
        
        self.profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(contentView.frame.height)
            make.trailing.equalTo(titleLabel.snp.leading).offset(-12.0)
        }
   
    }
    
    func update(with user: User) {
        self.profileImageView.kf.setImage(
            with: URL(string: user.profileImage ?? ""),
            placeholder: Constants.profileDefaultImage
        )
        self.titleLabel.text = "\(user.name) 님의 다이어리"
    }
}
