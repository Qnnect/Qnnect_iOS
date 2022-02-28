//
//  AddGroupCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/18.
//

import UIKit
import Then
import SnapKit

final class AddCafeCell: UICollectionViewCell {
    static let identifier = "AddGroupCell"
    
    private let addGroupIcon = UIImageView(image: Constants.groupPlusImage).then {
        $0.contentMode = .scaleAspectFit
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
        self.contentView.addSubview(self.addGroupIcon)
        
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.addGroupCellBorder?.cgColor
        self.contentView.layer.cornerRadius = Constants.homeCellCornerRadius
        
        self.addGroupIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(20.0)
        }
    }
}
