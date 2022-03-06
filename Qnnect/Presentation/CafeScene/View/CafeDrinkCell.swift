//
//  GroupDrinkCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/05.
//

import UIKit
import SnapKit
import Then

final class CafeDrinkCell: UICollectionViewCell {
    static let identifier = "CafeDrinkCell"
    
    private let drinkImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let userNameLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 10.0)
        $0.textColor = .GRAY01
        $0.textAlignment = .center
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
            self.drinkImageView,
            self.userNameLabel
        ].forEach {
            self.contentView.addSubview($0)
        }
        
        self.drinkImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        self.userNameLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.drinkImageView.snp.bottom).offset(10.0)
        }
    }
    
    func update(with cafeUser: CafeUser) {
        self.drinkImageView.image = cafeUser.userDrinkSelected != nil ? Constants.basicDrinkImage : Constants.notSelectDrinkImage
        self.userNameLabel.text = cafeUser.userInfo.name
    }
}
