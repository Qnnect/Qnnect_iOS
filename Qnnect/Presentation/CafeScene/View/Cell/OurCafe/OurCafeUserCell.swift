//
//  CafeUserCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/17.
//

import UIKit
import Then
import SnapKit
import Kingfisher

final class OurCafeUserCell: UICollectionViewCell {
    
    static let identifier = "OurCafeUserCell"
    
    private(set) var profileImageView = CircleImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let nameLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 12.0)
        $0.textColor = .GRAY03
        $0.textAlignment = .center
        $0.sizeToFit()
    }
    
    override var isSelected: Bool {
        didSet {
            nameLabel.textColor = isSelected ? .black : .GRAY03
            profileImageView.layer.borderWidth = isSelected ? 2.0 : 0.0
            profileImageView.layer.borderColor = isSelected ? UIColor.p_brown?.cgColor : nil
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    

    private func configureUI() {
        
        [
            profileImageView,
            nameLabel
        ].forEach {
            contentView.addSubview($0)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(nameLabel.snp.top).offset(-10.0)
            make.height.equalTo(profileImageView.snp.width)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
    
    func update(with user: OurCafeUser) {
        profileImageView.kf.setImage(
            with: URL(string: user.profileImage ?? ""),
            placeholder: Constants.profileDefaultImage)
        
        nameLabel.text = user.nickName
    }
    
}
