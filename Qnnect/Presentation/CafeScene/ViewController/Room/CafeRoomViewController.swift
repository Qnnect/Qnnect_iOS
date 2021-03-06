//
//  GroupRoomViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/22.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxDataSources
import Toast_Swift
import Alamofire

final class CafeRoomViewController: BaseViewController {
    
    private let mainCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    ).then {
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.register(
            CafeTitleCell.self,
            forCellWithReuseIdentifier: CafeTitleCell.identifier
        )
        $0.register(
            CafeDrinkCell.self,
            forCellWithReuseIdentifier: CafeDrinkCell.identifier
        )
        $0.register(
            CafeToDayQuestionCell.self,
            forCellWithReuseIdentifier: CafeToDayQuestionCell.identifier
        )
        $0.register(
            PageControlFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: PageControlFooterView.identifier
        )
        $0.register(
            CafeQuestionEmptyCell.self,
            forCellWithReuseIdentifier: CafeQuestionEmptyCell.idendifier
        )
        $0.backgroundColor = .p_ivory
    }
    
    private let questionButton = UIButton().then {
        $0.setTitle("내가 질문하기", for: .normal)
        $0.setTitleColor(.GRAY03, for: .normal)
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 12.0)
        $0.layer.borderWidth = 1.2
        $0.layer.borderColor = UIColor.groupDrinksBorder?.cgColor
        $0.layer.cornerRadius = 16.0
    }
    
    private let navigationTitleView = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .GRAY01
        $0.textAlignment = .center
        $0.frame = .init(x: 0, y: 0, width: 200.0, height: 0.0)
    }
    
    private let navigationMenuButton = UIButton().then {
        $0.setImage(Constants.navigationMenuImage, for: .normal)
    }
    
    private let navigationQuestionListButton = UIButton().then {
        $0.setImage(Constants.navigationRecipeImage, for: .normal)
    }
    
    private var todayQuestionCurPage = 0 {
        didSet {
            guard let view = self.mainCollectionView.supplementaryView(
                forElementKind: UICollectionView.elementKindSectionFooter,
                at: IndexPath(row: 0, section: 2)) as? PageControlFooterView
            else { return }
            
            if view.pageControl.numberOfPages > 0 {
                view.pageControl.currentPage = self.todayQuestionCurPage
            }
        }
    }
    
    private var groupDrinksCurPage = 0 {
        didSet {
            guard let view = self.mainCollectionView.supplementaryView(
                forElementKind: UICollectionView.elementKindSectionFooter,
                at: IndexPath(row: 0, section: 1)) as? PageControlFooterView
            else { return }
            
            if view.pageControl.numberOfPages > 0 {
                view.pageControl.currentPage = self.todayQuestionCurPage
            }
        }
    }
    
    private var viewModel: CafeRoomViewModel!
    private var cafeId: Int!
    weak var coordinator: CafeCoordinator?
    
    static func create(
        with viewModel: CafeRoomViewModel,
        _ cafeId: Int,
        _ coordinator: CafeCoordinator
    ) -> CafeRoomViewController{
        let vc = CafeRoomViewController()
        vc.viewModel = viewModel
        vc.cafeId = cafeId
        vc.coordinator = coordinator
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.mainCollectionView.numberOfSections > 1 {
            self.setDrinksEmptyView(self.mainCollectionView.numberOfItems(inSection: 1) == 0)
        }
    }
    
    override func configureUI() {
        
        [
            self.mainCollectionView,
            self.questionButton
        ].forEach {
            self.view.addSubview($0)
        }
        
        self.questionButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(11.0)
            make.height.equalTo(36.0)
            make.leading.trailing.equalToSuperview().inset(20.0)
        }

        self.mainCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(questionButton.snp.top).offset(-8.0)
        }

        
        let layout = self.createLayout()
        
        layout.register(
            CafeDrinksSectionDecorationView.self,
            forDecorationViewOfKind: CafeDrinksSectionDecorationView.identifier
        )
        
        self.mainCollectionView.collectionViewLayout = layout
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: self.navigationMenuButton),
            UIBarButtonItem(customView: self.navigationQuestionListButton)
        ]
        
    }
    
    override func bind() {
        
        let didTapDrinkSelectButton = PublishSubject<Void>()
        
        let input = CafeRoomViewModel.Input(
            viewDidLoad: Observable.just(Void()),
            viewWillAppear: Observable.merge(
                self.rx.viewWillAppear.mapToVoid(),
                self.rx.methodInvoked(#selector(self.comebackCafeRoom)).mapToVoid()),
            cafeId: Observable.just(self.cafeId),
            didTapQuestionButton: self.questionButton.rx.tap.asObservable(),
            didTapDrinkSelectButton: didTapDrinkSelectButton.asObservable(),
            viewDidAppear: self.rx.viewDidAppear.mapToVoid(),
            didTapNavigationMenu: self.navigationMenuButton.rx.tap.asObservable(),
            didTapQuestionCell: self.mainCollectionView.rx.modelSelected(CafeRoomSectionItem.self)
                .compactMap {
                    item -> Question? in
                    guard case let CafeRoomSectionItem.todayQuestionSectionItem(question) = item else {
                        return nil
                    }
                    return question
                },
            didTapQuestionListButton: navigationQuestionListButton.rx.tap.asObservable(),
            didTapDrinkSection: Observable.merge(
                rx.methodInvoked(#selector(didTapDrinkSection)).mapToVoid(),
                mainCollectionView.rx.itemSelected.filter{ $0.section == 1}.mapToVoid()
                )
        )
        
        let output = self.viewModel.transform(from: input)
        
        let dataSource = self.createDataSource(drinkSelectButtonObserver: didTapDrinkSelectButton.asObserver())
        
        Observable.zip(
            output.currentDrinkInfo.asObservable(),
            output.userDrinkInfos.asObservable(),
            output.roomInfo.asObservable().do {
                [weak self] cafe in
                self?.navigationTitleView.text = cafe.title
                self?.navigationItem.titleView = self?.navigationTitleView
            }
        ).map({
            currentDrinkInfo, userDrinkInfos, cafe -> [CafeRoomSectionModel] in
            let cafeTitleSectionItem = CafeRoomSectionItem.titleSectionItem(
                cafe: cafe,
                drinkInfo: currentDrinkInfo
            )
            let cafeDrinksSectionItems = userDrinkInfos.map {
                CafeRoomSectionItem.cafeDrinksSectionItem(curStpe: $0.curStep, drink: $0.drink, name: $0.name)
            }
            var cafeToDayQuestionSectionItems = cafe.questions.map{ CafeRoomSectionItem.todayQuestionSectionItem(question: $0)}
            
            if cafeToDayQuestionSectionItems.isEmpty {
                cafeToDayQuestionSectionItems = [CafeRoomSectionItem.questionEmptySectionItem]
            }
            return [
                CafeRoomSectionModel.titleSection(title: "", items: [cafeTitleSectionItem]),
                CafeRoomSectionModel.cafeDrinksSection(title: "", items: cafeDrinksSectionItems),
                CafeRoomSectionModel.todayQuestionSection(title: "", items: cafeToDayQuestionSectionItems)
            ]
        })
            .bind(to:self.mainCollectionView.rx.items(dataSource: dataSource))
        .disposed(by: self.disposeBag)
        
        output.enterError
            .emit(onNext: {
                [weak self] _ in
                guard let self = self else { return }
                self.view.makeToast(
                    "음료를 선택해야 카페에 입장할 수 있습니다.",
                    position: .bottom
                )
            }).disposed(by: self.disposeBag)
        
        guard let coordinator = coordinator else { return }
        
        
        output.showDrinkSelectGuideAlertView
            .emit(onNext: coordinator.showDrinkSelectGuideAlertView)
            .disposed(by: self.disposeBag)
        
        output.showDrinkSelectBottomSheet
            .emit(onNext: coordinator.showSelectDrinkBottomSheet(_:))
            .disposed(by: self.disposeBag)
        
        output.showSettingBottomSheet
            .emit(onNext: coordinator.showSettingBottomSheet)
            .disposed(by: self.disposeBag)
        
        output.showCafeQuestionScene
            .emit(onNext: coordinator.showCafeQuestionScene(_:))
            .disposed(by: self.disposeBag)
        
        output.showWriteQuestionScene
            .emit(onNext: coordinator.showWriteQuestionScene(_:))
            .disposed(by: self.disposeBag)
        
        output.showCafeQuestionListScene
            .emit(onNext: coordinator.showCafeQuestionListScene(_:))
            .disposed(by: self.disposeBag)
        
        output.showOurCafeScene
            .emit(onNext: coordinator.showOurCafeScene)
            .disposed(by: self.disposeBag)
    }
    
    @objc dynamic func comebackCafeRoom() {
    }
}

private extension CafeRoomViewController {
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { section, environment -> NSCollectionLayoutSection?
            in
            switch section {
            case 0:
                return self.createGroupTitleLayout()
            case 1:
                return self.createGroupDrinkLayout()
            case 2:
                return self.createToDayQuestionLayout()
            default:
                return nil
            }
        }
    }
    
    func createGroupTitleLayout() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 20.0, bottom: 0, trailing: 20.0)
        
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.314))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        //section.contentInsets = .init(top: 26.0, leading: 0, bottom: 0.0, trailing: 0)
        
        return section
    }
    
    func createGroupDrinkLayout() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(0.17))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 5)
        //group.contentInsets = .init(top: 24.0, leading: 0, bottom: 0, trailing: 0)
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.decorationItems = [
            NSCollectionLayoutDecorationItem.background(
                elementKind: CafeDrinksSectionDecorationView.identifier
            )
        ]
        
        section.boundarySupplementaryItems = [self.createDrinksSectionFooter()]
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.visibleItemsInvalidationHandler = {
            items, contentOffset, environment in
            let point = contentOffset
            let env = environment
            self.groupDrinksCurPage = Int(max(0, round(point.x / env.container.contentSize.width)))
        }
        section.contentInsets = .init(top: 0, leading: 20.0, bottom: 0, trailing: 20.0)
        return section
    }
    
    func createToDayQuestionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 20.0, bottom: 0, trailing: 20.0)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [self.createSectionFooter()]
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.visibleItemsInvalidationHandler = {
            items, contentOffset, environment in
            let point = contentOffset
            let env = environment
            self.todayQuestionCurPage = Int(max(0, round(point.x / env.container.contentSize.width)))
        }
        section.contentInsets = .init(top: 12.0, leading: 0, bottom: 0, trailing: 0)
        
        
        return section
    }
    
    func createSectionFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        //Section Footer 사이즈
        let layoutSectionFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(6.0))
        
        //Section Footer layout
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionFooterSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        
        sectionFooter.contentInsets = .init(top: 8.0, leading: 0, bottom: 0, trailing: 0)
        return sectionFooter
    }
    
    func createDrinksSectionFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        //Section Footer 사이즈
        let layoutSectionFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(4.0))
        
        //Section Footer layout
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionFooterSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        sectionFooter.contentInsets = .init(top: 0, leading: 0, bottom: -20.0, trailing: 0)
        return sectionFooter
    }
    
    func createDataSource(drinkSelectButtonObserver: AnyObserver<Void>) -> RxCollectionViewSectionedReloadDataSource<CafeRoomSectionModel> {
        return RxCollectionViewSectionedReloadDataSource { dataSoruce, collectionView, indexPath, item in
            switch item {
            case .titleSectionItem(cafe: let cafe, drinkInfo: let drinkInfo):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CafeTitleCell.identifier,
                    for: indexPath
                ) as! CafeTitleCell
                cell.update(with: cafe, drinkInfo: drinkInfo)
                cell.drinkSelectButton.rx.tap
                    .bind(to: drinkSelectButtonObserver)
                    .disposed(by: self.disposeBag)
                return cell
            case .cafeDrinksSectionItem(curStpe: let curStep, drink: let drink, name: let name):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CafeDrinkCell.identifier,
                    for: indexPath
                ) as! CafeDrinkCell
                cell.update(with: curStep, drink, name)
                return cell
            case .todayQuestionSectionItem(question: let question):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CafeToDayQuestionCell.identifier,
                    for: indexPath
                ) as! CafeToDayQuestionCell
                cell.update(with: question)
                return cell
            case .questionEmptySectionItem:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CafeQuestionEmptyCell.idendifier,
                    for: indexPath
                ) as! CafeQuestionEmptyCell
                return cell
            }
        }configureSupplementaryView: {
            [weak self] dataSource, collectionView, kind, indexPath in
            guard let self = self else { return UICollectionReusableView() }
            if indexPath.section == 2 {
                let view = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionFooter,
                    withReuseIdentifier: PageControlFooterView.identifier,
                    for: indexPath
                ) as! PageControlFooterView
                if let item = dataSource.sectionModels[2].items.first {
                    if case CafeRoomSectionItem.questionEmptySectionItem = item {
                        view.pageControl.isHidden = true
                        return view
                    } else {
                        view.pageControl.isHidden = false
                    }
                }
                let pageCount = dataSource.sectionModels[2].items.count
                view.pageControl.numberOfPages = pageCount == 1 ? 0 : pageCount
                view.pageControl.numberOfPages = dataSource.sectionModels[2].items.count
                view.pageControl.currentPage = self.todayQuestionCurPage
                return view
            } else if indexPath.section == 1 {
                let view = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionFooter,
                    withReuseIdentifier: PageControlFooterView.identifier,
                    for: indexPath
                ) as! PageControlFooterView
                let pageCount = (dataSource.sectionModels[1].items.count  / 6 + 1)
                view.pageControl.numberOfPages = pageCount == 1 ? 0 : pageCount
                view.pageControl.isEnabled = false
                view.pageControl.subviews.forEach {
                    $0.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                }
                view.pageControl.currentPage = self.groupDrinksCurPage
                
                return view
            }
            return UICollectionReusableView()
        }
    }
    
    func setDrinksEmptyView(_ isEmpty: Bool) {
        guard let decoView = self.mainCollectionView.subviews.first(
            where: {
                $0 is CafeDrinksSectionDecorationView
            }
        ) as? CafeDrinksSectionDecorationView,
              let footerView = mainCollectionView.supplementaryView(
                forElementKind: UICollectionView.elementKindSectionFooter,
                at: IndexPath(row: 0, section: 1)) as? PageControlFooterView
        else { return }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapDrinkSection))
        
        if decoView.gestureRecognizers == nil || decoView.gestureRecognizers?.isEmpty ?? true {
            decoView.isUserInteractionEnabled = true
            decoView.addGestureRecognizer(tapGesture)
        }
        
        decoView.emptyLabel.isHidden = !isEmpty
        footerView.pageControl.isHidden = isEmpty
    }
    
    @objc func didTapDrinkSection() {
        print("didTapDrinkSection")
    }
}
