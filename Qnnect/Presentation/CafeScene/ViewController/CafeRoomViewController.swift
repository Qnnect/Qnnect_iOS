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
    
    private var viewModel: CafeRoomViewModel!
    private var cafeId: Int!
    
    static func create(
        with viewModel: CafeRoomViewModel,
        _ cafeId: Int
    ) -> CafeRoomViewController{
        let vc = CafeRoomViewController()
        vc.viewModel = viewModel
        vc.cafeId = cafeId
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
        [
            self.mainCollectionView,
            self.questionButton
        ].forEach {
            self.view.addSubview($0)
        }
        
        self.mainCollectionView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
        }
        
        self.questionButton.snp.makeConstraints { make in
            make.top.equalTo(self.mainCollectionView.snp.bottom).offset(14.0)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(11.0)
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.height.equalTo(36.0)
        }
        
        let layout = self.createLayout()
        layout.register(
            CafeDrinksSectionDecorationView.self,
            forDecorationViewOfKind: CafeDrinksSectionDecorationView.identifier
        )
        self.mainCollectionView.collectionViewLayout = layout
    }
    
    override func bind() {
        
        let input = CafeRoomViewModel.Input(
            viewDidLoad: Observable.just(Void()),
            viewWillAppear: self.rx.viewWillAppear.mapToVoid(),
            cafeId: Observable.just(cafeId)
        )
        
        let output = self.viewModel.transform(from: input)
        
        let dataSource = self.createDataSource()
        
        output.roomInfo
            .do {
                [weak self] cafe in
                self?.navigationItem.title = cafe.title
            }
            .map({ cafe -> [CafeRoomSectionModel] in
                let cafeTitleSectionItem = CafeRoomSectionItem.titleSectionItem(cafe: cafe)
                let cafeDrinksSectionItems = cafe.cafeUsers.map { CafeRoomSectionItem.cafeDrinksSection(cafeUser: $0)}
                let cafeToDayQuestionSectionItems = cafe.questions.map{ CafeRoomSectionItem.todayQuestionSectionItem(question: $0)}
                
                return [
                    CafeRoomSectionModel.titleSection(title: "", items: [cafeTitleSectionItem]),
                    CafeRoomSectionModel.cafeDrinksSection(title: "", items: cafeDrinksSectionItems),
                    CafeRoomSectionModel.todayQuestionSection(title: "", items: cafeToDayQuestionSectionItems)
                ]
            })
            .drive(self.mainCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
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
                return self.createGroupDrinkCell()
            case 2:
                return self.createToDayQuestionCell()
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
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(140.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 26.0, leading: 0, bottom: 0, trailing: 0)
        
        return section
    }
    
    func createGroupDrinkCell() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 24.0, leading: 15.0, bottom: 24.0, trailing: 15.0)
        
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(124.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 5)
       
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.decorationItems = [
            NSCollectionLayoutDecorationItem.background(
                elementKind: CafeDrinksSectionDecorationView.identifier
            )
        ]
        section.contentInsets = .init(top: 26.0, leading: 20.0, bottom: 0, trailing: 20.0)
        return section
    }
    
    func createToDayQuestionCell() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 20.0, bottom: 0, trailing: 20.0)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(246.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        //section
        let section = NSCollectionLayoutSection(group: group)
//        section.boundarySupplementaryItems = [createSectionHeader(),createTodayQuestionSectionFooter()]
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        //section.visibleItemsInvalidationHandler = self.visibleItemsInvalidationHandler
        section.contentInsets = .init(top: 12.0, leading: 0, bottom: 15.0, trailing: 0)
        
        
        return section
    }
    
    func createDataSource() -> RxCollectionViewSectionedReloadDataSource<CafeRoomSectionModel> {
        return RxCollectionViewSectionedReloadDataSource { dataSoruce, collectionView, indexPath, item in
            switch item {
            case .titleSectionItem(cafe: let cafe):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CafeTitleCell.identifier,
                    for: indexPath
                ) as! CafeTitleCell
                cell.update(with: cafe)
                return cell
            case .cafeDrinksSection(cafeUser: let cafeUser):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CafeDrinkCell.identifier,
                    for: indexPath
                ) as! CafeDrinkCell
                cell.update(with: cafeUser)
                return cell
            case .todayQuestionSectionItem(question: let question):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CafeToDayQuestionCell.identifier,
                    for: indexPath
                ) as! CafeToDayQuestionCell
                cell.update(with: question)
                return cell
            }
        }
    }
}

import SwiftUI
struct GroupRoomViewController_Priviews: PreviewProvider {
    static var previews: some View {
        Contatiner().edgesIgnoringSafeArea(.all)
    }
    struct Contatiner: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            let cafeRepository = DefaultCafeRepository(cafeNetworkService: CafeNetworkService())
            let cafeUseCase = DefaultCafeUseCase(cafeRepository: cafeRepository)
            let vc = CafeRoomViewController.create(
                with: CafeRoomViewModel(
                    coordinator: DefaultGroupCoordinator(
                        navigationController: UINavigationController()),
                    cafeUseCase: cafeUseCase
                ),
                 12
            )
            return vc
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

        }
        typealias UIViewControllerType =  UIViewController
    }
}
