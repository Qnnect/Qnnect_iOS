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
        $0.contentMode = .scaleAspectFit
    }
    
    private(set) var drinkSelectButton = UIButton().then {
        $0.backgroundColor = .PINK01
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
            make.top.equalToSuperview().inset(26.0)
            make.leading.equalToSuperview()
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.createdDateLabel.snp.bottom).offset(5.0)
            make.leading.equalToSuperview()
            make.trailing.equalTo(self.drinkImageView.snp.leading).offset(-16.0)
        }
        
        self.drinkImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(35.23)
            make.trailing.equalToSuperview().inset(55.0)
            make.top.equalToSuperview().inset(25.6)
            make.width.equalTo((contentView.frame.height - 35.23 - 25.6) / 2.05)
        }
        
        self.drinkSelectButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(drinkImageView.snp.bottom)
            make.height.equalTo(34.0)
            make.width.equalTo(94.0)
        }
    }
    
    func update(with cafe: Cafe, drinkInfo: (curStep: DrinkStep, drink: DrinkType)?) {
        self.nameLabel.text = cafe.title
        self.createdDateLabel.text = "\(cafe.createdAt)~"
       
        guard let drinkInfo = drinkInfo else {
            drinkImageView.image = Constants.notSelectDrinkImage

            return
        }
        
        drinkSelectButton.isHidden = true
        drinkImageView.image =
        drinkInfo.curStep == .completed ?
        drinkInfo.drink.getDrinkCompletionImage() : drinkInfo.drink.getDrinkStepImage(drinkInfo.curStep)
    
    }
}


