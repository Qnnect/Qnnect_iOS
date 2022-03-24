//
//  ProductCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/17.
//

import UIKit
import SnapKit
import Then

final class IngredientCell: UICollectionViewCell {
    static let identifier = "ProductCell"
    
    private let icon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let title = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 12.0)
        $0.textColor = .blackLabel
        $0.textAlignment = .center
    }
    
    private let price = UILabel().then {
        $0.font = .BM_JUA(size: 12.0)
        $0.textColor = .blackLabel
    }
    
    private let priceIcon = UIImageView(image: Constants.priceImage)
    
    private let priceView = UIView().then {
        $0.backgroundColor = .secondaryBackground
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
            self.icon,
            self.title,
            self.priceView
        ].forEach {
            self.contentView.addSubview($0)
        }
        
        [
            self.price,
            self.priceIcon
        ].forEach {
            self.priceView.addSubview($0)
        }
        
        self.contentView.backgroundColor = .secondaryBackground
        self.contentView.layer.cornerRadius = 16.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.brownBorderColor?.cgColor
        self.contentView.layer.masksToBounds = true
        
        self.icon.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16.0)
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.height.equalTo(90.0)
        }
        
        self.title.snp.makeConstraints { make in
            make.top.equalTo(self.icon.snp.bottom).offset(18.0)
            make.leading.trailing.equalToSuperview().inset(8.0)
        }
        
        self.priceView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.top.equalTo(self.title.snp.bottom).offset(5.0)
        }
        
        self.priceIcon.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        self.price.snp.makeConstraints { make in
            make.leading.equalTo(self.priceIcon.snp.trailing).offset(8.0)
            make.top.bottom.trailing.equalToSuperview()
        }
    }
    
    func update(with ingredient: Ingredient) {
        self.icon.image = UIImage(named:ingredient.name)
        if ingredient.name == "얼음" {
            icon.snp.updateConstraints { make in
                make.height.equalTo(110.0)
            }
            title.snp.updateConstraints { make in
                make.top.equalTo(icon.snp.bottom).offset(-2.0)
            }
        } else {
            icon.snp.updateConstraints { make in
                make.height.equalTo(90.0)
            }
            title.snp.updateConstraints { make in
                make.top.equalTo(icon.snp.bottom).offset(18.0)
            }
        }
        
        self.price.text = "\(ingredient.price)"
        self.title.text = ingredient.name
    }
}
