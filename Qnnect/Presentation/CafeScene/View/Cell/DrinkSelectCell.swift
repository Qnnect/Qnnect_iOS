//
//  DrinkSelectCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/11.
//

import UIKit
import SnapKit
import Then

final class DrinkSelectCell: UICollectionViewCell {
    static let identifier = "DrinkSelectCell"
    
    private let drinkImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let drinkLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.textColor = .GRAY01
        $0.sizeToFit()
    }
    
    var isChecked: Bool = false {
        didSet {
            contentView.layer.borderColor = isChecked ? UIColor.p_brown?.cgColor : UIColor.groupDrinksBorder?.cgColor
            contentView.layer.borderWidth = isChecked ? 2.5 : 1.0
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
            drinkImageView,
            drinkLabel
        ].forEach {
            contentView.addSubview($0)
        }
        
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.groupDrinksBorder?.cgColor
        contentView.layer.cornerRadius = 16.0
        
        drinkImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(25.0)
            make.leading.trailing.equalToSuperview().inset(50.0)
        }
        
        drinkLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(26.0)
            //TODO: Change
            make.top.equalTo(self.drinkImageView.snp.bottom).offset(20.0)
        }
    }
    
    func update(with drink: Drink) {
        drinkLabel.text = drink.name
        
        switch drink.id {
        case 1:
            drinkImageView.image = Constants.strawberryLatte_step_3
        case 2:
            drinkImageView.image = Constants.lemonade_step_3
        case 3:
            drinkImageView.image = Constants.mintChoco_step_3
        case 4:
            drinkImageView.image = Constants.chocoLatte_step_3
        case 5:
            drinkImageView.image = Constants.summerLatte_step_3
        default:
            drinkImageView.image = Constants.drinkEmptyImage
        }
    }
}
