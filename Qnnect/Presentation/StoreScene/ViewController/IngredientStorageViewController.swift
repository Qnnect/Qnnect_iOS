//
//  IngredientStorageViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/18.
//

import UIKit
import SnapKit
import Then
import RxDataSources
import RxSwift
import RxCocoa

final class IngredientStorageViewController: BaseViewController {
    
    private let navigationTitleLabel = NavigationTitleLabel(title: "재료 보관함")
    
    private let ingredientCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    ).then {
        $0.backgroundColor = .p_ivory
        $0.showsVerticalScrollIndicator = false
        $0.register(IngredientStorageCell.self, forCellWithReuseIdentifier: IngredientStorageCell.identifier)
        $0.register(
            StoreSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: StoreSectionHeaderView.identifier
        )
    }
    
    private let layout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        let width = UIScreen.main.bounds.width / 2.0 - 8.0 - 20.0
        let height = width * 1.08
        $0.itemSize = .init(width: width, height: height)
        $0.sectionInset = .init(top: 0, left: 20.0, bottom: 0, right: 20.0)
    }
    
    private var viewModel: IngredientStorageViewModel!
    weak var coordinator: StorageCoordinator?
    
    static func create(
        with viewModel: IngredientStorageViewModel,
        _ coordinator: StorageCoordinator
    ) -> IngredientStorageViewController {
        let vc = IngredientStorageViewController()
        vc.viewModel = viewModel
        vc.coordinator = coordinator
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
        view.addSubview(ingredientCollectionView)
        
        ingredientCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        navigationItem.titleView = navigationTitleLabel
    }
    
    override func bind() {
        super.bind()
        
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
        
        let input = IngredientStorageViewModel.Input(
            viewDidLoad: Observable.just(()),
            didTapIngredientTag: selectedTag.asObservable(),
            didTapWholeTag: selectedWholeTag.asObservable()
        )
        
        let output = viewModel.transform(from: input)
        
        output.ingredients
            .do {
                [weak self] ingredients in
                guard let self = self else { return }
                if ingredients.isEmpty, self.ingredientCollectionView.backgroundView == nil {
                    self.layout.headerReferenceSize = .init(width: UIScreen.main.bounds.width, height: 0)
                    self.ingredientCollectionView.collectionViewLayout = self.layout
                    self.ingredientCollectionView.setEmptyView(message: "구매한 재료가 없어요")
                } else {
                    self.layout.headerReferenceSize = .init(width: UIScreen.main.bounds.width, height: 60.0)
                    self.ingredientCollectionView.collectionViewLayout = self.layout
                    self.ingredientCollectionView.reset()
                }
            }
            .map {
                 ingredients -> [StorageSectionModel] in
                let items = ingredients.map { StorageSectionItem.IngredientSectionItem(ingredient: $0)}
                return [StorageSectionModel.IngredientSection(title: "", items: items)]
            }.drive(ingredientCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)

    }
}

private extension IngredientStorageViewController {
    func createDataSource() -> RxCollectionViewSectionedReloadDataSource<StorageSectionModel> {
        return RxCollectionViewSectionedReloadDataSource { dataSource, collectionView, indexPath, item in
            switch item {
            case .IngredientSectionItem(ingredient: let ingredient):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IngredientStorageCell.identifier, for: indexPath) as! IngredientStorageCell
                cell.update(with: ingredient)
                return cell
            }
        }
    }
}

