//
//  DrinkSelectGuideAlertView.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/07.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class DrinkSelectGuideAlertView: BaseViewController {
    
    private let titleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .blackLabel
        $0.numberOfLines = 2
    }
    
    private let secondaryLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 12.0)
        $0.textColor = .GRAY03
    }
    
    private let cancleButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.WHITE_FFFFFF, for: .normal)
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        $0.backgroundColor = .GRAY04
        $0.layer.cornerRadius = 10.0
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.GRAY03?.cgColor
    }
    
    private let goDrinkSelectButton = UIButton().then {
        $0.setTitle("음료 고르기", for: .normal)
        $0.setTitleColor(.WHITE_FFFFFF, for: .normal)
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        $0.backgroundColor = .p_brown
        $0.layer.cornerRadius = 10.0
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.BLACK_121212?.cgColor
    }
    
    private let buttonStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        $0.spacing = 12.0
    }
    
    private let alertView = UIView().then {
        $0.backgroundColor = .p_ivory
        $0.layer.cornerRadius = 16.0
    }
    
    private var viewModel: DrinkSelectGuideAlertViewModel!
    private var type: UserBehaviorType!
    
    static func create(with viewModel: DrinkSelectGuideAlertViewModel, _ type: UserBehaviorType) -> DrinkSelectGuideAlertView {
        let view = DrinkSelectGuideAlertView()
        view.viewModel = viewModel
        view.type = type
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
        [
            self.cancleButton,
            self.goDrinkSelectButton
        ].forEach {
            self.buttonStackView.addArrangedSubview($0)
        }
        
        [
            self.titleLabel,
            self.secondaryLabel,
            self.buttonStackView
        ].forEach {
            self.alertView.addSubview($0)
        }
        
        self.view.addSubview(self.alertView)
        self.view.backgroundColor = .black.withAlphaComponent(0.5)
        
        self.alertView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(28.0)
            make.height.equalTo(200.0)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(25.0)
            make.centerX.equalToSuperview()
        }
        
        let paragraphStyle = Constants.paragraphStyle
        paragraphStyle.alignment = .center
        self.titleLabel.attributedText = NSAttributedString(
            string: type.notSelectGuideTitleMessage,
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        
        self.secondaryLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(6.0)
            make.centerX.equalToSuperview()
        }
        
        self.secondaryLabel.text = type.notSelectGuideSecondaryMessage
        
        self.buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.bottom.equalToSuperview().inset(25.0)
            make.height.equalTo(50.0)
        }
    }
    
    override func bind() {
        
        let input = DrinkSelectGuideAlertViewModel.Input(
            didTapCancleButton: self.cancleButton.rx.tap.asObservable(),
            didTapDrinkSelectButton: self.goDrinkSelectButton.rx.tap.asObservable()
        )
        
        let output = self.viewModel.transform(from: input)
        
        output.dismiss
            .emit()
            .disposed(by: self.disposeBag)
    }
}
