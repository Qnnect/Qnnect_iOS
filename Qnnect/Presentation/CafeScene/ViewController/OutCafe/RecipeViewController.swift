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
        //TODO: 유저가 선택한 음료의 결과물 로 change
        $0.image = Constants.strawberryLatte_step_3
    }
    
    private let drinkNameLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .BLACK_121212
        //TODO: Change
        $0.text = "딸기라떼"
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
        $0.distribution = .equalCentering
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
            make.centerY.equalToSuperview().multipliedBy(0.6)
            make.leading.trailing.equalToSuperview().inset(130.0)
        }
        
        drinkNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(drinkImageView.snp.bottom).offset(27.0)
        }
        
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(drinkNameLabel.snp.bottom).offset(46.0)
            make.leading.trailing.equalToSuperview().inset(50.0)
        }
        
        stepLabelStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(45.0)
            make.top.equalTo(progressBar.snp.bottom).offset(8.0)
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
            make.top.equalTo(stepLabelStackView.snp.bottom).offset(10.0)
            make.height.equalTo((UIScreen.main.bounds.width - 105.0) / 4.0)
        }
        
        recipeInfoLabelStackView.snp.makeConstraints { make in
            make.top.equalTo(ingredientImageStackView.snp.bottom).offset(18.0)
            make.leading.trailing.equalTo(stepLabelStackView)
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
                        $0.backgroundColor = .secondaryBackground
                    }
                    let imageView = UIImageView(image: UIImage(named: ingredient.name))
                    imageView.contentMode = .scaleAspectFit
                    view.addSubview(imageView)
                    imageView.snp.makeConstraints { make in
                        make.edges.equalToSuperview()
                    }
                    
                    let label = UILabel().then {
                        $0.font = .IM_Hyemin(.bold, size: 12.0)
                        $0.numberOfLines = 2
                        $0.textColor = .BLACK_121212
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.lineHeightMultiple = 1.23
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
        
        guard let coordinator = coordinator else { return }

        output.showStoreScene
            .emit(onNext: coordinator.showStoreScene)
            .disposed(by: self.disposeBag)
    }
    
    @objc dynamic func didTapStoreButton() { }
}


