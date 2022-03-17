//
//  IngredientStorageCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/17.
//

import UIKit
import SnapKit
import Then

final class IngredientStorageCell: UICollectionViewCell {
    static let identifier = "IngredientStorageCell"
    
    private let icon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let title = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 12.0)
        $0.textColor = .blackLabel
        $0.textAlignment = .center
    }
    
    private let countLabel = UILabel().then {
        $0.font = .BM_JUA(size: 12.0)
        $0.textColor = .blackLabel
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
            icon,
            title,
            countLabel
        ].forEach {
            contentView.addSubview($0)
        }
        
        
        self.contentView.backgroundColor = .secondaryBackground
        self.contentView.layer.cornerRadius = 16.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.brownBorderColor?.cgColor
        self.contentView.layer.masksToBounds = true
        
        self.icon.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16.0)
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.bottom.equalTo(title.snp.top).offset(-10.0)
        }
        icon.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        self.title.snp.makeConstraints { make in
            make.bottom.equalTo(countLabel.snp.top).offset(-5.0)
            make.leading.trailing.equalToSuperview().inset(8.0)
        }
        
        self.countLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(17.0)
            make.centerX.equalToSuperview()
        }
        
        
 
    }
    
    func update(with ingredient: MyIngredient) {
        self.icon.image = UIImage(named:ingredient.name)
        self.title.text = ingredient.name
        countLabel.text = "x\(ingredient.count)"
        contentView.bringSubviewToFront(title)
        contentView.bringSubviewToFront(countLabel)
    }
}

