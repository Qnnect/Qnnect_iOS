//
//  RightStepAlertViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/18.
//


import UIKit
import SnapKit
import Then
import RxSwift

final class RightStepAlertViewController: BaseViewController {
    
    private let ingredientsImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .blackLabel
        $0.numberOfLines = 2
    }
    
    private let secondaryLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 12.0)
        $0.textColor = .GRAY03
        $0.text = "재료가 소진되니 신중하게 넣어주세요"
        $0.textAlignment = .center
    }
    
    private(set) var okButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.WHITE_FFFFFF, for: .normal)
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        $0.backgroundColor = .p_brown
        $0.layer.cornerRadius = 10.0
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.BLACK_121212?.cgColor
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
    
    private let buttonStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.spacing = 12.0
    }
    private let alertView = UIView().then {
        $0.backgroundColor = .p_ivory
        $0.layer.cornerRadius = 16.0
    }
    
    
    private var ingredient: MyIngredient!
    weak var coordinator: OurCafeCoordinator?
    private var userDrinkSelectedId: Int!
    private var viewModel: RightStepAlertViewModel!
    
    weak var delegate: InsertIngredientDelegate?
    
    static func create(
        with viewModel: RightStepAlertViewModel,
        _ coordinator: OurCafeCoordinator,
        _ ingredient: MyIngredient,
        _ userDrinkSelectedId: Int
    ) -> RightStepAlertViewController {
        let view = RightStepAlertViewController()
        view.ingredient = ingredient
        view.coordinator = coordinator
        view.userDrinkSelectedId = userDrinkSelectedId
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let navigationVC = presentingViewController as? UINavigationController {
            navigationVC.viewControllers.last?.viewWillAppear(true)
        } 
    }
    
    override func configureUI() {
        
        [
            ingredientsImageView,
            titleLabel,
            secondaryLabel,
            buttonStackView
        ].forEach {
            alertView.addSubview($0)
        }
        
        [
            okButton,
            cancleButton
        ].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        view.addSubview(alertView)
        view.backgroundColor = .black.withAlphaComponent(0.5)
        
        ingredientsImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60.0)
            make.leading.trailing.equalToSuperview().inset(110.0)
        }
        ingredientsImageView.image = UIImage(named: ingredient.name)
        
        alertView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(28.0)
            make.height.equalTo(370.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ingredientsImageView.snp.bottom).offset(45)
            make.leading.trailing.equalToSuperview().inset(32.0)
        }
        
        let paragraphStyle = Constants.paragraphStyle
        paragraphStyle.alignment = .center
        titleLabel.attributedText = NSAttributedString(
            string: "정말 '\(ingredient.name)'를 사용하시겠나요?",
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        
        
        secondaryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(11.0)
            make.centerX.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.bottom.equalToSuperview().inset(25.0)
            make.height.equalTo(50.0)
        }
        
    }
    
    override func bind() {
        super.bind()
        
        cancleButton.rx.tap
            .subscribe(onNext: {
                [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
        
        let input = RightStepAlertViewModel.Input(
            didTapOkButton: okButton.rx.tap.asObservable(),
            ingredientsId: Observable.just(ingredient).map { $0.ingredientId},
            userDrinkSelectedId: Observable.just(userDrinkSelectedId)
        )
        
        let output = viewModel.transform(from: input)
        
        guard let coordinator = coordinator else { return }

        output.insert
            .emit(onNext: coordinator.dismiss)
            .disposed(by: self.disposeBag)
    }
}
