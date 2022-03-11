//
//  GroupTitleCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/05.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class CafeTitleCell: UICollectionViewCell {
    static let identifier = "CafeTitleCell"
    
    private let createdDateLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 12.0)
        $0.textColor = .GRAY03
    }
    
    private let nameLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 20.0)
        $0.textColor = .BLACK_121212
        $0.numberOfLines = 0
    }
    
    private let drinkImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private(set) var drinkSelectButton = UIButton().then {
        $0.backgroundColor = .ORANGE01
        $0.setTitle("음료 선택하기", for: .normal)
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 12.0)
        $0.setTitleColor(.GRAY01, for: .normal)
        $0.layer.cornerRadius = 17.0
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.brownBorderColor?.cgColor
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
            self.createdDateLabel,
            self.nameLabel,
            self.drinkImageView,
            self.drinkSelectButton
        ].forEach {
            self.contentView.addSubview($0)
        }
        
        self.createdDateLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.createdDateLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalTo(self.drinkImageView.snp.leading).inset(16.0)
        }
        
        self.drinkImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(17.0)
            make.trailing.equalToSuperview().inset(75.0)
            make.top.equalToSuperview().inset(20.0)
        }
        
        self.drinkSelectButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(34.0)
            make.width.equalTo(94.0)
        }
    }
    
    func update(with cafe: Cafe) {
        self.nameLabel.text = cafe.title
        self.createdDateLabel.text = "\(cafe.createdAt)~"
        self.setCurrentUserDrink(isSelected: cafe.currentUser.userDrinkSelected != nil)
    }
    
}

private extension CafeTitleCell {
    func setCurrentUserDrink(isSelected: Bool) {
        if isSelected {
            self.drinkImageView.image = Constants.basicDrinkImage
            self.drinkSelectButton.isHidden = true
        } else {
            self.drinkImageView.image = Constants.notSelectDrinkImage
            self.drinkSelectButton.isHidden = false
        }
    }
}
