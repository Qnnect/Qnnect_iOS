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
        $0.font = .IM_Hyemin(.bold, size: 12.0)
        $0.textColor = .GRAY01
        $0.textAlignment = .center
        $0.text = "fdsfa"
        $0.sizeToFit()
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
        
        
        self.userNameLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
        userNameLabel.setContentHuggingPriority(.required, for: .vertical)
        userNameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        self.drinkImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(userNameLabel.snp.top).offset(-10.0)
        }
        
    }
    
    func update(with curStep: DrinkStep?, _ drink: DrinkType?, _ name: String) {
        self.userNameLabel.text = name
        
        guard let curStep = curStep, let drink = drink else {
            drinkImageView.image = Constants.notSelectDrinkImage
            return
        }
        
        drinkImageView.image = drink.getDrinkStepImage(curStep)
    }
}
