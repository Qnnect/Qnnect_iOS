//
//  InsertIngredientViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/17.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

final class InsertIngredientViewController: BaseViewController {
    
    private let navigationTitleLabel = NavigationTitleLabel(title: "재료넣기")
    
    private let drinkImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let progressBar = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let stepLabelStackView = UIStackView().then {
        $0.distribution = .equalCentering
    }
        
    private let ingredientStorageLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 18.0)
        $0.textColor = .black
        $0.text = "재료 보관함"
    }
    
    private let fullViewButton = UIButton().then {
        $0.setTitle("전체보기", for: .normal)
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 12.0)
        $0.setTitleColor(.GRAY03, for: .normal)
        $0.backgroundColor = .p_ivory
        $0.sizeToFit()
    }
    
    private let viewRecipeButton = UIButton().then {
        $0.setTitle("레시피 보기", for: .normal)
        $0.setTitleColor(.GRAY01, for: .normal)
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 14.0)
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.secondaryBorder?.cgColor
        $0.layer.cornerRadius = 16.0
    }
    
    private let ingredientCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    ).then {
        $0.backgroundColor = .p_ivory
        $0.register(IngredientStorageCell.self, forCellWithReuseIdentifier: IngredientStorageCell.identifier)
        $0.isScrollEnabled = false
        $0.showsVerticalScrollIndicator = false
    }
    
    private let emptyView = UIView().then {
        $0.backgroundColor = .secondaryBackground
        $0.layer.cornerRadius = 16.0
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.brownBorderColor?.cgColor
    }
    
    private let emptyLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 12.0)
        $0.textColor = .p_brown
        $0.numberOfLines = 2
        $0.attributedText = NSAttributedString(
            string: "재료가 없습니다\n상점에서 재료를 구매하세요",
            attributes: [NSAttributedString.Key.paragraphStyle: Constants.paragraphStyle]
        )
    }
    
    private lazy var wrongStepAlertView = WrongStepAlertView().then {
        $0.modalPresentationStyle = .overCurrentContext
    }
    
    weak var coordinator: OurCafeCoordinator?
    private var viewModel: InsertIngredientViewModel!
    private var cafeId: Int!
    
    static func create(
        with viewModel: InsertIngredientViewModel,
        _ coordinator: OurCafeCoordinator,
        _ cafeId: Int
    ) -> InsertIngredientViewController {
        let vc = InsertIngredientViewController()
        vc.viewModel = viewModel
        vc.cafeId = cafeId
        vc.coordinator = coordinator
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func configureUI() {
        super.configureUI()
        
        [
            viewRecipeButton,
            drinkImageView,
            progressBar,
            stepLabelStackView,
            ingredientStorageLabel,
            fullViewButton,
            ingredientCollectionView,
            emptyView
        ].forEach {
            view.addSubview($0)
        }
        
        emptyView.addSubview(emptyLabel)
        
        viewRecipeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(27.0)
            make.trailing.equalToSuperview().inset(21.0)
            make.width.equalTo(100.0)
            make.height.equalTo(36.0)
        }
        
        drinkImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(130.0)
            make.centerY.equalToSuperview().multipliedBy(0.68)
        }
        
        progressBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(50.0)
            make.top.equalTo(drinkImageView.snp.bottom).offset(30.0)
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
            }
            stepLabelStackView.addArrangedSubview(label)
        }
        
        ingredientStorageLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20.0)
            make.bottom.equalTo(ingredientCollectionView.snp.top).offset(-16.0)
        }
        
        fullViewButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(21.0)
            make.bottom.equalTo(ingredientCollectionView.snp.top).inset(-22.0)
        }
        
        ingredientCollectionView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(100.0)
        }
        ingredientCollectionView.collectionViewLayout = createLayout()
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.bottom.equalToSuperview().inset(57.0)
            make.top.equalTo(ingredientStorageLabel.snp.bottom).offset(15.0)
        }
        
        navigationItem.titleView = navigationTitleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: Constants.navi_store,
            style: .plain,
            target: self,
            action: #selector(didTapStoreButton)
        )
    }
    
    override func bind() {
        super.bind()
        
        ingredientCollectionView.rx.methodInvoked(#selector(ingredientCollectionView.reloadData))
            .subscribe(onNext: {
                [weak self] _ in
                guard let self = self else { return }
                let height = self.ingredientCollectionView.collectionViewLayout.collectionViewContentSize.height
                self.ingredientCollectionView.snp.updateConstraints { make in
                    make.height.equalTo(height)
                }
            }).disposed(by: self.disposeBag)
        
        let input = InsertIngredientViewModel.Input(
            viewWillAppear: rx.viewWillAppear.mapToVoid(),
            cafeId: Observable.just(cafeId),
            didTapRecipeButton: viewRecipeButton.rx.tap.asObservable(),
            didTapStoreButton: rx.methodInvoked(#selector(didTapStoreButton)).mapToVoid(),
            didTapFullViewButton: fullViewButton.rx.tap.asObservable(),
            didTapIngredientCell: ingredientCollectionView.rx.modelSelected(MyIngredient.self)
                .asObservable()
        )
        
        let output = viewModel.transform(from: input)
        
       
        output.ingredients
            .do {
                [weak self] ingredients in
                if ingredients.isEmpty {
                    self?.ingredientCollectionView.isHidden = true
                    self?.emptyView.isHidden = false
                } else {
                    self?.ingredientCollectionView.isHidden = false
                    self?.emptyView.isHidden = true
                }
            }
            .drive(ingredientCollectionView.rx.items(
                cellIdentifier: IngredientStorageCell.identifier,
                cellType: IngredientStorageCell.self
            )) { index, ingredient, cell in
                cell.update(with: ingredient)
            }.disposed(by: self.disposeBag)
        
        output.curStep
            .debug()
            .drive(onNext: {
                [weak self] curStep in
                self?.progressBar.image = curStep.progressBarImage
                self?.drinkImageView.image = curStep.drinkImage
                self?.setCurStepLabelColor(curStep)
            }).disposed(by: self.disposeBag)
        
        output.drinkState
            .debug()
            .drive(onNext: {
                [weak self] drinkState in
                self?.stepLabelStackView.subviews.enumerated().forEach({
                    index, view in
                    guard let label = view as? UILabel else { return }
                    label.text = """
                                \(DrinkStep(rawValue: index)?.title ?? "")
                                \(drinkState[index].filled)/\(drinkState[index].target)
                                """
                })
            }).disposed(by: self.disposeBag)
        
        guard let coordinator = coordinator else { return }
        
        output.showRecipeScene
            .emit(onNext: coordinator.showRecipeScene)
            .disposed(by: self.disposeBag)
        
        output.showStoreScene
            .emit(onNext: coordinator.showStoreScene)
            .disposed(by: self.disposeBag)
        
        output.showIngredientStorageScene
            .emit(onNext: coordinator.showIngredientStorageScene)
            .disposed(by: self.disposeBag)
        
        output.showWrongStepAlertView
            .emit(onNext: {
                [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.present(self.wrongStepAlertView, animated: true)
            }).disposed(by: self.disposeBag)
        
        output.showRightStepAlertView
            .emit(onNext: coordinator.showRightStepAlertView)
            .disposed(by: self.disposeBag)
        
        output.showCompleteDrinkScene
            .emit(onNext: coordinator.showCompleteDrinkScene)
            .disposed(by: self.disposeBag)
    }
}

private extension InsertIngredientViewController {
    func setCurStepLabelColor(_ curStep: DrinkStep) {
        guard curStep != .completed else { return }
        
        stepLabelStackView.subviews.enumerated().forEach { index, view in
            guard let label = view as? UILabel else { return }
            label.textColor = index == curStep.rawValue ? .ORANGE01 : .BLACK_121212
        }
    }
}

private extension InsertIngredientViewController {
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout {
            [weak self] section, environment -> NSCollectionLayoutSection? in
            switch section {
            case 0:
                return self?.createIngredientStorageSection()
            default:
                return nil
            }
        }
    }
    
    func createIngredientStorageSection() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
    
      
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .fractionalWidth(0.424))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.contentInsets = .init(top: 0, leading: 19.0, bottom: 0, trailing: 0)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(16.0)
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0.0, leading: 0, bottom: 56.0, trailing: 0)
        
        return section
    }
    
    @objc dynamic func didTapStoreButton() { }
    
}
