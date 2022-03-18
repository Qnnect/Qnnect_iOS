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
    
    private(set) var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 26.0
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
            make.bottom.equalToSuperview().priority(.high)
        }
        
    }
    
    func update(with user: OurCafeUser) {
        profileImageView.kf.setImage(
            with: URL(string: user.profileImage),
            placeholder: Constants.profileDefaultImage
        )
        
        nameLabel.text = user.nickName
    }
    
    func setSelectionStyle(_ isChecked: Bool) {
        contentView.layer.borderColor = isChecked ? UIColor.black.cgColor : UIColor.clear.cgColor
        contentView.layer.borderWidth = isChecked ? 1.0 : 0.0
    }
}
