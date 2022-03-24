//
//  MyDrinkStampHeaderView.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/22.
//

import UIKit
import SnapKit
import Then

final class MyDrinkStampTitleCell: UICollectionViewCell {
    static let identifier = "MyDrinkStampTitleCell"
    
    private let mainLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 20.0)
        $0.textColor = .GRAY01
        $0.numberOfLines = 2
    }
    
    private let secondaryLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.textColor = .secondaryBorder
        $0.numberOfLines = 2
        let paragraphStyle = Constants.paragraphStyle
        paragraphStyle.alignment = .left
        $0.attributedText = NSMutableAttributedString(
            string: "카페에서 음료를 완성하면\n스탬프가 채워져요!",
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
    }
    
    
    private let characterImageView = UIImageView(image: Constants.completionCelebrateImage).then {
        $0.contentMode = .scaleAspectFit
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
            mainLabel,
            secondaryLabel,
            characterImageView
        ].forEach {
            contentView.addSubview($0)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview()
        }
        mainLabel.setContentHuggingPriority(.required, for: .vertical)
        
        secondaryLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(6.0)
            make.leading.equalTo(mainLabel)
            make.bottom.equalToSuperview()
        }
        
        secondaryLabel.setContentCompressionResistancePriority(.fittingSizeLevel, for: .vertical)
        
        characterImageView.snp.makeConstraints { make in
            make.top.equalTo(mainLabel)
            make.bottom.equalTo(secondaryLabel)
            make.trailing.equalToSuperview().inset(29.0)
            make.leading.equalTo(mainLabel.snp.trailing).offset(12.0)
        }
        
        characterImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
    }
    
    func update(with user: User) {
        let paragraphStyle = Constants.paragraphStyle
        paragraphStyle.alignment = .left
        mainLabel.attributedText = NSMutableAttributedString(
            string: "\(user.name)님의\n적립 스탬프",
            attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle]
        )
    }
}
