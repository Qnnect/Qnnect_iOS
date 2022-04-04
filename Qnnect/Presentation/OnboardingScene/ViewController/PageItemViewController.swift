//
//  PageItemViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import UIKit
import SnapKit
import Then

final class PageItemViewController: BaseViewController {
    
    private(set) var mainImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private(set) var mainLabel = UILabel().then {
        $0.textColor = .GRAY01
        $0.font = .IM_Hyemin(.bold, size: 20.0)
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    
    private(set) var secondaryLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.textColor = .GRAY02
        $0.numberOfLines = 0
    }
    
    private var type: OnboardingSceneType!
    
    static func create(with type: OnboardingSceneType) -> PageItemViewController {
        let vc = PageItemViewController()
        vc.type = type
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
        [
            self.mainImageView,
            self.mainLabel,
            self.secondaryLabel
        ].forEach {
            self.view.addSubview($0)
        }
        
        let paragraphStyle = Constants.paragraphStyle
        paragraphStyle.alignment = .center
        
        self.mainLabel.attributedText = NSAttributedString(
            string: type.mainTitle,
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        
        self.secondaryLabel.attributedText = NSAttributedString(
            string: type.secondaryTitle,
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        
        self.mainImageView.image = type.image
        
        switch self.type {
        case .question:
            self.mainImageView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(108.0)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.centerY).multipliedBy(1.17)
            }
            
            self.mainLabel.snp.makeConstraints { make in
                make.top.equalTo(self.mainImageView.snp.bottom).offset(45.0)
                make.leading.trailing.equalToSuperview()
            }
            
            self.secondaryLabel.snp.makeConstraints { make in
                make.top.equalTo(self.mainLabel.snp.bottom).offset(37.0)
                make.leading.trailing.equalToSuperview().inset(35.0)
            }
            
        case .connection:
            self.mainImageView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.centerY).multipliedBy(1.18)
            }
            
            self.mainLabel.snp.makeConstraints { make in
                make.top.equalTo(self.mainImageView.snp.bottom).offset(28.0)
                make.leading.trailing.equalToSuperview()
            }
            
            self.secondaryLabel.snp.makeConstraints { make in
                make.top.equalTo(self.mainLabel.snp.bottom).offset(21.0)
                make.leading.trailing.equalToSuperview().inset(35.0)
            }
        case .drink:
            self.mainImageView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(119.0)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.centerY).multipliedBy(1.1428)
            }
            
            self.mainLabel.snp.makeConstraints { make in
                make.top.equalTo(self.mainImageView.snp.bottom).offset(37.0)
                make.leading.trailing.equalToSuperview()
            }
            
            self.secondaryLabel.snp.makeConstraints { make in
                make.top.equalTo(self.mainLabel.snp.bottom).offset(18.0)
                make.leading.trailing.equalToSuperview().inset(35.0)
            }
        case .stamp:
            self.mainImageView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(76.0)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.centerY).multipliedBy(1.08)
            }
            
            self.mainLabel.snp.makeConstraints { make in
                make.top.equalTo(self.mainImageView.snp.bottom).offset(85.0)
                make.leading.trailing.equalToSuperview()
            }
            
            self.secondaryLabel.snp.makeConstraints { make in
                make.top.equalTo(self.mainLabel.snp.bottom).offset(18.0)
                make.leading.trailing.equalToSuperview().inset(35.0)
            }
        case .none:
            break
        }
    }

}
