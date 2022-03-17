//
//  StoreViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/16.
//

import UIKit
import SnapKit
import Then
import KakaoSDKCommon
import TTGTags
import RxSwift
import RxDataSources

enum IngredientType: String, CaseIterable, Codable {
    case ice_base
    case main
    case topping
    
    var title: String {
        switch self {
        case .ice_base:
            return "얼음ㆍ베이스"
        case .main:
            return "주 재료"
        case .topping:
            return "토핑"
        }
    }
}
// MARK: - 상점 Scene
final class StoreViewController: BaseViewController {
    
    private let navigationTitleView = UILabel().then {
        $0.text = "상점"
        $0.font = .IM_Hyemin(.bold, size: 18.0)
        $0.textColor = .BLACK_121212
    }
    
    private let navigationTitleLabel = NavigationTitleLabel(title: "상점")
    
    private let ingredientCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        $0.backgroundColor = .p_ivory
        $0.showsVerticalScrollIndicator = false
        $0.register(IngredientCell.self, forCellWithReuseIdentifier: IngredientCell.identifier)
        $0.register(
            StoreSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: StoreSectionHeaderView.identifier
        )
    }
    
    private var viewModel: StoreViewModel!
    weak var coordinator: StoreCoordinator?
    
    static func create(
        with viewModel: StoreViewModel,
        _ coordinator: StoreCoordinator
    ) -> StoreViewController {
        let vc = StoreViewController()
        vc.viewModel = viewModel
        vc.coordinator = coordinator
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = .init(width: UIScreen.main.bounds.width / 2.0 - 8.0 - 20.0, height: Constants.ingredientCellHeight)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 20.0)
        layout.headerReferenceSize = CGSize(width: ingredientCollectionView.frame.width, height: 60.0)
        ingredientCollectionView.collectionViewLayout = layout
    }
    override func configureUI() {
        
        [
            self.ingredientCollectionView
        ].forEach {
            self.view.addSubview($0)
        }
        
        self.view.backgroundColor = .p_ivory
        
        if navigationController?.viewControllers.count == 1 {
            self.navigationItem.leftBarButtonItems =
                [
                    Constants.navigationLeftPadding,
                    UIBarButtonItem(customView: self.navigationTitleView)
                ]
        } else  {
            self.navigationItem.titleView = navigationTitleLabel
        }
       
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: Constants.store_navigation_bar_icon,
            style: .plain,
            target: self,
            action: #selector(didTapStorageButton)
        )

        
        self.ingredientCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
    }
    
    override func bind() {
        let selectedTag = PublishSubject<IngredientType>()
        let selectedWholeTag = PublishSubject<Void>()
        
        let dataSource = self.createDataSource()
        dataSource.configureSupplementaryView = { dataSource, collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                let view = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: StoreSectionHeaderView.identifier,
                    for: indexPath
                ) as! StoreSectionHeaderView
                view.tagCollectionView.rx.methodInvoked(#selector(view.tagCollectionView.textTagCollectionView(_:didTap:at:)))
                    .compactMap {
                        param -> IngredientType? in
                        let index = param[2] as! Int
                        if index == 0 {
                            selectedWholeTag.onNext(())
                            return nil
                        }
                        return IngredientType.allCases[index - 1]
                    }.subscribe(selectedTag)
                    .disposed(by: self.disposeBag)

                return view
            } else {
                return UICollectionReusableView()
            }
        }

        
        let input = StoreViewModel.Input(
            didTapIngredient: self.ingredientCollectionView.rx.modelSelected(StoreSectionItem.self)
                .map{ item -> Ingredient in
                    switch item {
                    case .IngredientSectionItem(ingredient: let ingredient):
                        return ingredient
                    }
                }
                .asObservable(),
            viewDidLoad: Observable.just(()),
            didTapIngredientTag: selectedTag.asObservable(),
            didTapWholeTag: selectedWholeTag.asObservable(),
            didTapStorageButton: rx.methodInvoked(#selector(didTapStorageButton)).mapToVoid()
        )
        
        let output = self.viewModel.transform(from: input)
        
        output.ingredients
            .map {
                 ingredients -> [StoreSectionModel] in
                let items = ingredients.map { StoreSectionItem.IngredientSectionItem(ingredient: $0)}
                return [StoreSectionModel.IngredientSection(title: "", items: items)]
            }.drive(self.ingredientCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        guard let coordinator = coordinator else { return}

        output.showIngredientBuyAlert
            .emit(onNext: coordinator.showIngredientBuyAlertView(with:))
            .disposed(by: self.disposeBag)
        
        output.showIngredientStorageScene
            .emit(onNext: coordinator.showIngredientStorageScene)
            .disposed(by: self.disposeBag)
    }
}

private extension StoreViewController {
    func createDataSource() -> RxCollectionViewSectionedReloadDataSource<StoreSectionModel> {
        return RxCollectionViewSectionedReloadDataSource { dataSource, collectionView, indexPath, item in
            switch item {
            case .IngredientSectionItem(ingredient: let ingredient):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IngredientCell.identifier, for: indexPath) as! IngredientCell
                cell.update(with: ingredient)
                return cell
            }
        }
    }
    
    @objc dynamic func didTapStorageButton() { }
}

