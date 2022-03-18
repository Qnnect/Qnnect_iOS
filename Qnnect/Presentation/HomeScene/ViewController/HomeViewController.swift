//
//  HomeViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/14.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxDataSources
import RxSwift
import RxAppState

final class HomeViewController: BaseViewController {
    
    private let homeCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    ).then {
        $0.register(TitleCell.self, forCellWithReuseIdentifier: TitleCell.identifier)
        $0.register(TodayQuestionCell.self, forCellWithReuseIdentifier: TodayQuestionCell.identifier)
        $0.register(MyCafeCell.self, forCellWithReuseIdentifier: MyCafeCell.identifier)
        $0.register(
            HomeSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeSectionHeaderView.identifier
        )
        $0.register(AddCafeCell.self, forCellWithReuseIdentifier: AddCafeCell.identifier)
        $0.register(
            HomeSectionFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: HomeSectionFooterView.identifier
        )
        $0.register(
            PageControlFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: PageControlFooterView.identifier
        )
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .p_ivory
    }
    
    private let pointImageView = UIImageView().then {
        $0.image = Constants.pointImage
        $0.contentMode = .scaleAspectFit
    }
    
    private let pointLabel = UILabel().then {
        $0.text = "nil"
        $0.font = .BM_JUA(size: 18.0)
        $0.textColor = .BLACK_121212
    }
    
    private let pointView = UIView().then {
        $0.backgroundColor = .p_ivory
    }
    
    @objc dynamic func visibleItemsInvalidationHandler(
        items: [NSCollectionLayoutVisibleItem],
        contentOffset: CGPoint,
        environment: NSCollectionLayoutEnvironment
    ) { }
    
    private var viewModel: HomeViewModel!
    weak var coordinator: HomeCoordinator?
    
    static func create(
        with viewModel: HomeViewModel,
        _ coordinator: HomeCoordinator
    ) -> HomeViewController {
        let vc = HomeViewController()
        vc.coordinator = coordinator
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
        [
            self.pointImageView,
            self.pointLabel,
        ].forEach {
            self.pointView.addSubview($0)
        }
        
        [
            self.homeCollectionView
        ].forEach {
            self.view.addSubview($0)
        }
        
        self.view.backgroundColor = .p_ivory
        
        //navigation Item
        self.navigationItem.leftBarButtonItems = [
            Constants.navigationLeftPadding,
            UIBarButtonItem(customView: self.pointView)
        ]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Constants.notificationIcon, style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        self.navigationController?.navigationBar.barTintColor = self.view.backgroundColor
        
        self.pointImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        self.pointLabel.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.equalTo(self.pointImageView.snp.trailing).offset(8.0)
        }
        
        self.homeCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.homeCollectionView.collectionViewLayout = self.createLayout()
        
    }
    
    override func bind() {
        
        let didTapAddGroupButton = PublishSubject<Void>()
        let didTapJoinCafebutton = PublishSubject<Void>()
        let curQuestionPage = PublishSubject<Int>()
        
        let datasource = self.createDataSource()
        datasource.configureSupplementaryView = { datasource, collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeSectionHeaderView.identifier, for: indexPath) as? HomeSectionHeaderView else  {
                    fatalError("Could not dequeReusableView")
                }
                let title = datasource.sectionModels[indexPath.section].title
                headerView.update(with: title)
                return headerView
            } else if indexPath.section == 2 {
                guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HomeSectionFooterView.identifier, for: indexPath) as? HomeSectionFooterView else {
                    fatalError("Could not dequeReusableView")
                }
                footerView.addCafeButton.rx.tap
                    .subscribe(didTapAddGroupButton.asObserver())
                    .disposed(by: self.disposeBag)
                footerView.joinCafeButton.rx.tap
                    .subscribe(didTapJoinCafebutton.asObserver())
                    .disposed(by: self.disposeBag)
                return footerView
            } else if indexPath.section == 1 {
                guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: PageControlFooterView.identifier, for: indexPath) as? PageControlFooterView else {
                    fatalError("Could not dequeReusableView")
                }
                
                footerView.pageControl.numberOfPages = datasource.sectionModels[1].items.count
                curQuestionPage
                    .subscribe(footerView.pageControl.rx.currentPage)
                    .disposed(by: self.disposeBag)
                return footerView
            }
            return UICollectionReusableView()
        }
        

        let input = HomeViewModel.Input(
            didTapAddGroupButton: didTapAddGroupButton.asObservable(),
            curQuestionPage:   self.rx.methodInvoked(#selector( HomeViewController.visibleItemsInvalidationHandler))
                .map{
                    param -> Int in
                    let point = param[1] as? CGPoint ?? .zero
                    let env = param[2] as! NSCollectionLayoutEnvironment
                    return Int(max(0, round(point.x / env.container.contentSize.width)))
                },
            viewWillAppear: self.rx.viewWillAppear.mapToVoid(),
            didTapMyCafe: self.homeCollectionView.rx.modelSelected(HomeSectionItem.self)
                .compactMap { item -> MyCafe? in
                    guard case let HomeSectionItem.myCafeSectionItem(cafe) = item else { return nil }
                    return cafe
                },
            didTapJoinCafeButton: didTapJoinCafebutton.asObservable(),
            didTapTodayQuestion: homeCollectionView.rx.modelSelected(HomeSectionItem.self)
                .compactMap({ item -> ToDayQuestion? in
                    guard case let HomeSectionItem.todayQuestionSectionItem(question) = item else { return nil }
                    return question
                })
        )
        
        
        
        let output = self.viewModel.transform(from: input)
        
                
        output.curQuestionPage
            .drive(curQuestionPage)
            .disposed(by: self.disposeBag)
        
        output.homeInfo
            .debug()
            .do {
                [weak self] homeInfo in
                self?.pointLabel.text = "\(homeInfo.user.point) P"
            }
            .map(self.convertToSectionModel(_:))
            .drive(self.homeCollectionView.rx.items(dataSource: datasource))
            .disposed(by: self.disposeBag)
        
        guard let coordinator = coordinator else { return }

        output.showCafeRoom
            .emit(onNext: coordinator.showGroupScene)
            .disposed(by: self.disposeBag)
        
        output.showAddGroupBottomSheet
            .emit(onNext: coordinator.showAddGroupBottomSheet)
            .disposed(by: self.disposeBag)

        output.showJoinCafeBottomSheet
            .emit(onNext: coordinator.showJoinCafeBottomSheet)
            .disposed(by: self.disposeBag)
        
        output.showCafeQuestionScene
            .emit(onNext: coordinator.showCafeQuestionScene(_:))
            .disposed(by: self.disposeBag)
    }
}

// MARK: - CollectionView CompositionLayout
private extension HomeViewController {
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] section, environment -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            switch section {
            case 0:
                return self.createTitleLayout()
            case 1:
                return self.createTodayQuestionLayout()
            case 2:
                return self.createMyGroupLayout()
            default:
                return nil
            }
        }
    }
    
    func createTitleLayout() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(0.9))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10.0, leading: 20.0, bottom: 0, trailing: 20.0)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(60.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 10.0, leading: 0, bottom: 10.0, trailing: 0)
        
        return section
    }
    
    func createTodayQuestionLayout() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 20.0, bottom: 0, trailing: 20.0)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [createSectionHeader(),createTodayQuestionSectionFooter()]
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.visibleItemsInvalidationHandler = self.visibleItemsInvalidationHandler
        section.contentInsets = .init(top: 0, leading: 0, bottom: 15.0, trailing: 0)
        
        return section
    }
    
    func createMyGroupLayout() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 20.0, bottom: 10, trailing: 0)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalWidth(0.45))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [createSectionHeader(),createSectionFooter()]
        section.contentInsets = .init(top: 0, leading: 0, bottom: 16.0, trailing: 0)
        
        return section
    }
    
    //SectionHeader layout설정
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        //Section Header 사이즈
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(46.0))
        
        //Section Header layout
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        sectionHeader.contentInsets = .init(top: 0, leading: 20.0, bottom: 0, trailing: 0)
        return sectionHeader
    }
    
    private func createSectionFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        //Section Footer 사이즈
        let layoutSectionFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(36.0))
        
        //Section Footer layout
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionFooterSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottomLeading)
        
        return sectionFooter
    }
    
    private func createTodayQuestionSectionFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        //Section Footer 사이즈
        let layoutSectionFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(6.0))
        
        //Section Footer layout
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionFooterSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        
        return sectionFooter
    }
}

// MARK: - RxDataSources
private extension HomeViewController {
    func createDataSource() -> RxCollectionViewSectionedReloadDataSource<HomeSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<HomeSectionModel> { datasource, collectionView, indexPath, item in
            switch item {
            case .titleSectionItem(user: let user):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCell.identifier, for: indexPath) as! TitleCell
                cell.update(with: user)
                return cell
            case .todayQuestionSectionItem(question: let question):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayQuestionCell.identifier, for: indexPath) as! TodayQuestionCell
                cell.update(with: question)
                return cell
            case.myCafeSectionItem(cafe: let cafe):
                //TODO: 일단 테스트를 위한 코드 ... 꼭 바꾸자 이 로직
//                if group.name == "마지막" {
//                    return collectionView.dequeueReusableCell(withReuseIdentifier: AddCafeCell.identifier, for: indexPath)
//                }
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCafeCell.identifier, for: indexPath) as! MyCafeCell
                cell.update(with: cafe)
                return cell
            case .todayQuestionSectionEmptyItem:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayQuestionCell.identifier, for: indexPath) as! TodayQuestionCell
                cell.emptyView.isHidden = false
                return cell
            }
        }
    }
    
    
    func convertToSectionModel(_ homeInfo: HomeInfo) -> [HomeSectionModel] {
        let titleItem = HomeSectionItem.titleSectionItem(user: homeInfo.user)
        var questionItem = homeInfo.questions.map { HomeSectionItem.todayQuestionSectionItem(question: $0) }
        let groupItem = homeInfo.cafes.map { HomeSectionItem.myCafeSectionItem(cafe: $0)}
        
        if questionItem.isEmpty {
            questionItem = [HomeSectionItem.todayQuestionSectionEmptyItem]
        }
        
        return [
            HomeSectionModel.titleSection(title: "", items: [titleItem]),
            HomeSectionModel.todayQuestionSection(title: "오늘의 질문", items: questionItem),
            HomeSectionModel.myCafeSection(title: "나의 카페", items: groupItem)
        ]
    }
}

