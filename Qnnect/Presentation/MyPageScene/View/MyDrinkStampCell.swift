//
//  MyDrinkStampCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/22.
//

import UIKit
import SnapKit
import Then

final class MyDrinkStampCell: UICollectionViewCell {
    static let identifier = "MyDrinkStampCell"
    
    private let outerView = CircleView().then {
        $0.layer.borderWidth = 1.5
        $0.layer.borderColor = UIColor.secondaryBorder?.cgColor
    }
    
    private let drinkImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let drinkNameLabel = UILabel().then {
        $0.textColor = .BLACK_121212
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.textAlignment = .center
        $0.text = "  "
        $0.sizeToFit()
    }
    
    private let cafeNameLabel = UILabel().then {
        $0.textColor = .secondaryBorder
        $0.font = .IM_Hyemin(.bold, size: 12.0)
        $0.textAlignment = .center
        $0.text = "  "
        $0.sizeToFit()
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
        
        outerView.addSubview(drinkImageView)
        
        [
            outerView,
            drinkNameLabel,
            cafeNameLabel
        ].forEach {
            contentView.addSubview($0)
        }
        outerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(contentView.frame.width)
        }
        
        outerView.setContentHuggingPriority(.required, for: .vertical)
        //outerView.setContentHuggingPriority(.required, for: .horizontal)
        
        drinkImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(28.0)
            make.top.bottom.equalToSuperview().inset(13.0)
        }
        
        
        cafeNameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        drinkNameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(outerView.snp.bottom).offset(11.0)
            make.bottom.equalTo(cafeNameLabel.snp.top).offset(-5.0)
        }

    }
    
    func update(with stamp: Stamp) {
        if stamp == Stamp.empty {
            drinkImageView.image = Constants.stampDefaultImage
            drinkNameLabel.text = "  "
            cafeNameLabel.text = "  "
            outerView.backgroundColor = UIColor.p_ivory
            drinkImageView.snp.updateConstraints { make in
                make.leading.trailing.equalToSuperview().inset(17.0)
                make.top.bottom.equalToSuperview().inset(21.0)
            }
        } else {
            let drink = DrinkType(rawValue: stamp.drinkName) ?? .strawberryLatte
            outerView.backgroundColor = drink.stampBackGroundColor
            drinkImageView.image = drink.getDrinkCompletionImage()
            drinkNameLabel.text = drink.rawValue
            cafeNameLabel.text = stamp.cafeName
            drinkImageView.snp.updateConstraints { make in
                make.leading.trailing.equalToSuperview().inset(28.0)
                make.top.bottom.equalToSuperview().inset(13.0)
            }
        }
        
    }
}
