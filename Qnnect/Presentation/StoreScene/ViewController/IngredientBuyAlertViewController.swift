//
//  IngredientBuyAlertView.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/28.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class IngredientBuyAlertViewController: BaseViewController {
    
    private let alertView = UIView().then {
        $0.backgroundColor = .p_ivory
        $0.layer.cornerRadius = 16.0
    }
    
    private let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let buyInfoLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .blackLabel
        $0.numberOfLines = 3
    }
    
    private let buyButton = UIButton().then {
        $0.setTitle("구매", for: .normal)
        $0.setTitleColor(.WHITE_FFFFFF, for: .normal)
        $0.backgroundColor = .p_brown
        $0.layer.cornerRadius = Constants.bottomButtonCornerRadius
    }
    
    private let dismissButton = UIButton().then {
        $0.setImage(Constants.xmarkImage, for: .normal)
    }
    
    private var ingredient: Ingredient!
    
    private var viewModel: IngredientBuyAlertViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func create(with ingredient: Ingredient,_ viewModel: IngredientBuyAlertViewModel) -> IngredientBuyAlertViewController {
        let vc = IngredientBuyAlertViewController()
        vc.ingredient = ingredient
        vc.viewModel = viewModel
        return vc
    }
    
    override func configureUI() {
        
        self.view.addSubview(self.alertView)
        self.view.backgroundColor = .shadowBackground
        
        [
            self.iconImageView,
            self.dismissButton,
            self.buyInfoLabel,
            self.buyButton
        ].forEach {
            self.alertView.addSubview($0)
        }
        
        self.dismissButton.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview()
            make.width.height.equalTo(48.0)
        }
        
        self.iconImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(105.0)
            make.top.equalToSuperview().inset(51.0)
            make.bottom.equalTo(self.buyInfoLabel.snp.top).offset(-28.0)
        }
        
        self.iconImageView.image = UIImage(named: ingredient.name)
        
        self.buyInfoLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(93.0)
            make.bottom.equalTo(self.buyButton.snp.top).offset(-34.0)
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.17
        paragraphStyle.lineBreakStrategy = .hangulWordPriority
        paragraphStyle.alignment = .center
        self.buyInfoLabel.attributedText = NSAttributedString(
            string: "\(ingredient.price)P \(ingredient.name)를 구매하시겠나여?",
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        
        self.buyButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(61.0)
            make.bottom.equalToSuperview().inset(36.0)
            make.height.equalTo(52.0)
        }
        
        self.alertView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(36.0)
            make.top.bottom.equalToSuperview().inset(210.0)
        }
    }
    
    override func bind() {
        
        let input = IngredientBuyAlertViewModel.Input(
            didTapDismissButton: self.dismissButton.rx.tap
                .asObservable(),
            didTapBuyButton: self.buyButton.rx.tap
                .mapToVoid()
                .map(self.getIngredient)
        )
        
        let output = self.viewModel.transform(from: input)
        
        output.dismiss
            .emit()
            .disposed(by: self.disposeBag)
        
        output.success
            .emit()
            .disposed(by: self.disposeBag)
        
        output.error
            .emit()
            .disposed(by: self.disposeBag)
    }
}

private extension IngredientBuyAlertViewController {
    func getIngredient() -> Ingredient {
        return self.ingredient
    }
}
