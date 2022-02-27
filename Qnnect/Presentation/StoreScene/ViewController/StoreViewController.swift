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

enum IngredientType: CaseIterable,Codable {
    case iceOrBase
    case main
    case topping
    
    var title: String {
        switch self {
        case .iceOrBase:
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
    
    private var viewModel: StoreViewModel!
    
    private let dummyData = [
        Ingredient(type: .iceOrBase, name: "얼음", price: 100),
        Ingredient(type: .iceOrBase, name: "얼음", price: 100),
        Ingredient(type: .iceOrBase, name: "물", price: 130),
        Ingredient(type: .iceOrBase, name: "카페인", price: 150),
        Ingredient(type: .iceOrBase, name: "얼음", price: 100),
        Ingredient(type: .iceOrBase, name: "카페인", price: 150),
        Ingredient(type: .iceOrBase, name: "얼음", price: 100),
        Ingredient(type: .iceOrBase, name: "물", price: 130),
        Ingredient(type: .iceOrBase, name: "우유", price: 110),
        Ingredient(type: .main, name: "녹차", price: 200),
        Ingredient(type: .main, name: "딸기", price: 300),
        Ingredient(type: .main, name: "초콜릿", price: 500),
        Ingredient(type: .main, name: "자몽", price: 400),
        Ingredient(type: .main, name: "토피넛", price: 150),
        Ingredient(type: .main, name: "히비스커스", price: 600),
        Ingredient(type: .main, name: "민트초코", price: 10),
        Ingredient(type: .topping, name: "휘핑크림", price: 100),
        Ingredient(type: .topping, name: "휘핑크림", price: 200),
        Ingredient(type: .topping, name: "휘핑크림", price: 300),
        Ingredient(type: .topping, name: "휘핑크림", price: 400),
        Ingredient(type: .topping, name: "휘핑크림", price: 500),
        Ingredient(type: .topping, name: "휘핑크림", price: 600)
    ]
    
    
    private let navigationTitleView = UILabel().then {
        $0.text = "상점"
        $0.font = .IM_Hyemin(.bold, size: 18.0)
        $0.textColor = .BLACK_121212
    }
    
    private let rightBarButtonView = UIImageView(image: Constants.store_navigation_bar_icon).then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let ingredientCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = .init(width: Constants.ingredientCellWidth, height: Constants.ingredientCellHeight)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 3.0, bottom: 0, right: 3.0)
        layout.headerReferenceSize = CGSize(width: $0.frame.width, height: 60.0)
        $0.collectionViewLayout = layout
        $0.backgroundColor = .p_ivory
        $0.showsVerticalScrollIndicator = false
        $0.register(IngredientCell.self, forCellWithReuseIdentifier: IngredientCell.identifier)
        $0.register(
            StoreSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: StoreSectionHeaderView.identifier
        )
    }
    
    static func create(with viewModel: StoreViewModel) -> StoreViewController {
        let vc = StoreViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
        [
            self.ingredientCollectionView
        ].forEach {
            self.view.addSubview($0)
        }
        
        self.view.backgroundColor = .p_ivory
        
        
        self.navigationItem.leftBarButtonItems =
            [
                Constants.navigationLeftPadding,
                UIBarButtonItem(customView: self.navigationTitleView)
            ]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.rightBarButtonView)
        self.navigationItem.rightBarButtonItem?.tintColor = .BLACK_121212

        
        self.ingredientCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(17.0)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
    }
    
    override func bind() {
        let selectedTagTitle = PublishSubject<String>()
        selectedTagTitle.subscribe(onNext: {
            print("tap!!!\($0)")
        })
            .disposed(by: self.disposeBag)
        let dataSource = self.createDataSource()
        dataSource.configureSupplementaryView = { dataSource, collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                let view = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: StoreSectionHeaderView.identifier,
                    for: indexPath
                ) as! StoreSectionHeaderView
                view.tagCollectionView.rx.tappedTagTitle.subscribe(selectedTagTitle.asObserver())
                    .disposed(by: self.disposeBag)
                return view
            } else {
                return UICollectionReusableView()
            }
        }
        Observable.just(dummyData)
            .map {
                 ingredients -> [StoreSectionModel] in
                let items = ingredients.map { StoreSectionItem.IngredientSectionItem(Ingredient: $0)}
                return [StoreSectionModel.IngredientSection(title: "", items: items)]
            }.bind(to: self.ingredientCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
}

private extension StoreViewController {
    func createDataSource() -> RxCollectionViewSectionedReloadDataSource<StoreSectionModel> {
        return RxCollectionViewSectionedReloadDataSource { dataSource, collectionView, indexPath, item in
            switch item {
            case .IngredientSectionItem(Ingredient: let ingredient):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IngredientCell.identifier, for: indexPath) as! IngredientCell
                cell.update(with: ingredient)
                return cell
            }
        }
    }
}

import SwiftUI
struct StoreViewController_Priviews: PreviewProvider {
    static var previews: some View {
        Contatiner().edgesIgnoringSafeArea(.all)
    }
    struct Contatiner: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            let vc = StoreViewController.create(
                with: StoreViewModel(
                    coordinator: DefaultStoreCoordinator(navigationController: UINavigationController())
                )
            ) //보고 싶은 뷰컨 객체
            return UINavigationController(rootViewController: vc)
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        typealias UIViewControllerType =  UIViewController
    }
}
