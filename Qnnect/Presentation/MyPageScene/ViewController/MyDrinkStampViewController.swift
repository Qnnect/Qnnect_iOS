//
//  MyDrinkStampViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/22.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxDataSources

enum DrinkType: String {
    case strawberryLatte = "딸기라떼"
    case mintChocoLatte = "민트초코"
    case chocoLatte = "초코라떼"
    case summnerLatte = "썸머라떼"
    case lemonade = "레몬에이드"
    
    func getDrinkStepImage(_ step: DrinkStep) -> UIImage? {
        switch self {
        case .strawberryLatte:
            switch step {
            case .ice:
                return Constants.drinkEmptyImage
            case .base:
                return  Constants.drinkIceStepImage
            case .main:
                return Constants.strawberryLatte_step_1
            case .topping:
                return Constants.strawberryLatte_step_2
            case .completed:
                return Constants.strawberryLatte_step_4
            }
        case .mintChocoLatte:
            switch step {
            case .ice:
                return Constants.drinkEmptyImage
            case .base:
                return  Constants.drinkIceStepImage
            case .main:
                return Constants.mintChoco_step_1
            case .topping:
                return Constants.mintChoco_step_2
            case .completed:
                return Constants.mintChoco_step_4
            }
        case .chocoLatte:
            switch step {
            case .ice:
                return Constants.drinkEmptyImage
            case .base:
                return Constants.drinkIceStepImage
            case .main:
                return Constants.chocoLatte_step_1
            case .topping:
                return Constants.chocoLatte_step_2
            case .completed:
                return Constants.chocoLatte_step_4
            }
        case .summnerLatte:
            switch step {
            case .ice:
                return Constants.drinkEmptyImage
            case .base:
                return Constants.drinkIceStepImage
            case .main:
                return Constants.summerLatte_step_1
            case .topping:
                return Constants.summerLatte_step_2
            case .completed:
                return Constants.summerLatte_step_4
            }
        case .lemonade:
            switch step {
            case .ice:
                return Constants.drinkEmptyImage
            case .base:
                return Constants.drinkIceStepImage
            case .main:
                return Constants.lemonade_step_1
            case .topping:
                return Constants.lemonade_step_2
            case .completed:
                return Constants.lemonade_step_4
            }
            
        }
    }
    
    /// 반짝이 없는 이미지
    func getDrinkCompletionImage() -> UIImage? {
        switch self {
        case .strawberryLatte:
            return Constants.strawberryLatte_step_3
        case .mintChocoLatte:
            return Constants.mintChoco_step_3
        case .chocoLatte:
            return Constants.chocoLatte_step_3
        case .summnerLatte:
            return Constants.summerLatte_step_3
        case .lemonade:
            return Constants.lemonade_step_3
        }
    }
    
    var stampBackGroundColor: UIColor? {
        switch self {
        case .strawberryLatte:
            return .diary_pink
        case .mintChocoLatte:
            return .diary_blue
        case .chocoLatte:
            return .brown60
        case .summnerLatte:
            return .myPageButtonBackgroud
        case .lemonade:
            return .diary_yellow
        }
    }
}

struct StampTestModel {
    let drink: DrinkType
    let cafeName: String
}

final class MyDrinkStampViewController: BaseViewController {
    
    private let navigationTitleLabel = NavigationTitleLabel(title: "내 음료 스탬프")
    
    private let stampCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    ).then {
        $0.register(MyDrinkStampCell.self, forCellWithReuseIdentifier: MyDrinkStampCell.identifier)
        $0.register(MyDrinkStampTitleCell.self, forCellWithReuseIdentifier: MyDrinkStampTitleCell.identifier)
        $0.backgroundColor = .p_ivory
        $0.showsVerticalScrollIndicator = false
    }
    
    private var viewModel: MyDrinkStampViewModel!
    private var user: User!
    weak var coordinator: MyPageCoordinator?
    
    static func create(
        with viewModel: MyDrinkStampViewModel,
        _ coordinator: MyPageCoordinator,
        _ user: User
    ) -> MyDrinkStampViewController {
        let vc = MyDrinkStampViewController()
        vc.user = user
        vc.coordinator = coordinator
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        
        view.addSubview(stampCollectionView)
        
        stampCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stampCollectionView.collectionViewLayout = createLayout()
        
        navigationItem.titleView = navigationTitleLabel
    }
    
    override func bind() {
        super.bind()
        
        let dataSource = createDataSource()
        
        let input = MyDrinkStampViewModel.Input(
            viewDidLoad: Observable.just(())
        )
        
        let output = viewModel.transform(from: input)
        
        output.stamps
            .asObservable()
            .withLatestFrom(Observable.just(user), resultSelector: { ($0, $1)})
            .map {
                stamps, user -> [MyDrinkStampSectionModel] in
                let titleSectionItem = MyDrinkStampSectionItem.titleSectionItem(user: user!)
                let stampSectionItem = stamps.map { MyDrinkStampSectionItem.stampSectionItem(stamp: $0)}
                return [
                    MyDrinkStampSectionModel.titleSection(items: [titleSectionItem]),
                    MyDrinkStampSectionModel.stampSection(items: stampSectionItem)
                ]
            }
            .bind(to: stampCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
}

private extension MyDrinkStampViewController {
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout {
            [weak self] section, environment -> NSCollectionLayoutSection? in
            switch section {
            case 0:
                return self?.createTitleSectionLayout()
            case 1:
                return self?.createStampSectionLayout()
            default:
                return nil
            }
        }
    }
    
    func createStampSectionLayout() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(10.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(10.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.interItemSpacing = .fixed(36.0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 19.0, leading: 20.0, bottom: 0, trailing: 20.0)
        section.interGroupSpacing = 25.0
        
        return section
    }
    
    func createTitleSectionLayout() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.135))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 50.0, leading: 0, bottom: 0.0, trailing: 0)
        
        return section
    }
    
    func createDataSource() -> RxCollectionViewSectionedReloadDataSource<MyDrinkStampSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<MyDrinkStampSectionModel> {
            dataSource, collectionView, indexPath, item in
            switch item {
            case .stampSectionItem(stamp: let stamp):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyDrinkStampCell.identifier, for: indexPath) as! MyDrinkStampCell
                cell.update(with: stamp)
                return cell
            case .titleSectionItem(user: let user):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MyDrinkStampTitleCell.identifier, for: indexPath
                ) as! MyDrinkStampTitleCell
                cell.update(with: user)
                return cell
            }
        }
    }
}

