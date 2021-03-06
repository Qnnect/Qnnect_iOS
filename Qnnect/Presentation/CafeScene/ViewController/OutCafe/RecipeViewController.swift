//
//  RecipeViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/18.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class RecipeViewController: BaseViewController {
    
    private let drinkImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let drinkNameLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .BLACK_121212
    }
    
    private let progressBar = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = Constants.drinkRecipeProgressBar
    }

    private let stepLabelStackView = UIStackView().then {
        $0.distribution = .equalCentering
    }
    
    private let ingredientImageStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.spacing = 15.0
        //$0.alignment = .center
    }
    
    private let recipeInfoLabelStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.spacing = 15.0
        $0.alignment = .top
    }
    
    private let drinkShadowImageView = UIImageView().then {
        $0.image = Constants.drinkShadow
        $0.contentMode = .scaleToFill
    }
    
    private let navigationTitleLabel = NavigationTitleLabel(title: "레시피 보기")
    
    weak var coordinator: OurCafeCoordinator?
    private var viewModel: RecipeViewModel!
    private var cafeId: Int!
    private var userDrinkSelectedId: Int!
    
    static func create(
        with viewModel: RecipeViewModel,
        _ coordinator: OurCafeCoordinator,
        cafeId: Int,
        userDrinkSelectedId: Int
    ) -> RecipeViewController {
        let vc = RecipeViewController()
        vc.viewModel = viewModel
        vc.coordinator = coordinator
        vc.cafeId = cafeId
        vc.userDrinkSelectedId = userDrinkSelectedId
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        
        [
            drinkShadowImageView,
            drinkImageView,
            drinkNameLabel,
            progressBar,
            stepLabelStackView,
            ingredientImageStackView,
            recipeInfoLabelStackView
        ].forEach {
            view.addSubview($0)
        }
        
        drinkImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(70.0)
            make.leading.trailing.equalToSuperview().inset(130.0)
            make.bottom.equalTo(drinkNameLabel.snp.top).offset(-32.0)
        }
        drinkImageView.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        
        drinkNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(progressBar.snp.top).offset(-80.0)
        }
        
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(drinkNameLabel.snp.bottom).offset(46.0)
            make.leading.trailing.equalToSuperview().inset(50.0)
            make.bottom.equalTo(stepLabelStackView.snp.top).offset(-8.0)
        }
        
        stepLabelStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(45.0)
            make.bottom.equalTo(ingredientImageStackView.snp.top).offset(-10.0)
        }
        
        var steps = DrinkStep.allCases
        steps.removeLast()
        steps.forEach { step in
            let label = UILabel().then {
                $0.font = .BM_JUA(size: 14.0)
                $0.textAlignment = .center
                $0.numberOfLines = 2
                $0.textColor = .BLACK_121212
                $0.text = step.title
            }
            stepLabelStackView.addArrangedSubview(label)
        }
        ingredientImageStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30.0)
            //make.top.equalTo(stepLabelStackView.snp.bottom).offset(10.0)
            make.height.equalTo((UIScreen.main.bounds.width - 105.0) / 4.0)
            make.bottom.equalTo(recipeInfoLabelStackView.snp.top).offset(-10.0)
        }
        
        recipeInfoLabelStackView.snp.makeConstraints { make in
            //make.top.equalTo(ingredientImageStackView.snp.bottom).offset(10.0)
            make.leading.trailing.equalTo(ingredientImageStackView)
            make.bottom.equalToSuperview().inset(132.0)
        }
        
        drinkShadowImageView.snp.makeConstraints { make in
            make.bottom.equalTo(drinkImageView).offset(5.0)
            make.leading.equalTo(drinkImageView).offset(9.12)
            make.trailing.equalTo(drinkImageView).offset(-9.81)
            make.height.equalToSuperview().multipliedBy(0.03694)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: Constants.navi_store,
            style: .plain,
            target: self,
            action: #selector(didTapStoreButton)
        )
    }
    
    override func bind() {
        super.bind()
        
        let input = RecipeViewModel.Input(
            viewDidLoad: Observable.just(()),
            cafeId: Observable.just(cafeId),
            userDrinkSelectedId: Observable.just(userDrinkSelectedId),
            didTapStoreButton: rx.methodInvoked(#selector(didTapStoreButton)).mapToVoid()
        )
        
        let output = viewModel.transform(from: input)
        
        output.recipe
            .drive(onNext: {
                [weak self] ingredients in
                ingredients.forEach { ingredient in
                    let view = UIView().then {
                        $0.layer.cornerRadius = 13.0
                        $0.backgroundColor = .myPageButtonBackgroud
                    }
                    let imageView = UIImageView(image: UIImage(named: ingredient.name))
                    imageView.contentMode = .scaleAspectFit
                    view.addSubview(imageView)
                    imageView.snp.makeConstraints { make in
                        make.edges.equalToSuperview()
                    }
                    
                    let label = UILabel().then {
                        $0.font = .IM_Hyemin(.bold, size: 12.0)
                        $0.numberOfLines = 0
                        $0.textColor = .BLACK_121212
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.lineHeightMultiple = 1.23
                        paragraphStyle.lineBreakStrategy = .hangulWordPriority
                        paragraphStyle.alignment = .center
                        $0.attributedText = NSAttributedString(
                            string: "\(ingredient.name)\nx\(ingredient.count)",
                            attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle]
                        )
                    }
                    self?.ingredientImageStackView.addArrangedSubview(view)
                    self?.recipeInfoLabelStackView.addArrangedSubview(label)
                }
            }).disposed(by: self.disposeBag)
        
        output.cafeDrink
            .drive(onNext: {
                [weak self] cafeDrink in
                self?.drinkImageView.image = cafeDrink.userDrink?.getDrinkCompletionImage()
                self?.drinkNameLabel.text = cafeDrink.userDrink?.rawValue
            }).disposed(by: self.disposeBag)
        
        guard let coordinator = coordinator else { return }

        output.showStoreScene
            .emit(onNext: coordinator.showStoreScene)
            .disposed(by: self.disposeBag)
    }
    
    @objc dynamic func didTapStoreButton() { }
}


