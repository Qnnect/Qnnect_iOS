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

final class GroupRoomViewController: BaseViewController {
    
    private let mainCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    ).then {
        $0.showsVerticalScrollIndicator = false
        $0.register(
            GroupTitleCell.self,
            forCellWithReuseIdentifier: GroupTitleCell.identifier
        )
        $0.register(
            GroupDrinkCell.self,
            forCellWithReuseIdentifier: GroupDrinkCell.identifier
        )
        $0.register(
            GroupToDayQuestionCell.self,
            forCellWithReuseIdentifier: GroupToDayQuestionCell.identifier
        )
        
    }
    
    
    private var viewModel: GroupRoomViewModel!
    
    static func create(with viewModel: GroupRoomViewModel) -> GroupRoomViewController{
        let vc = GroupRoomViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        self.view.addSubview(self.mainCollectionView)
        
        self.mainCollectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.leading.equalToSuperview().inset(20.0)
        }
        self.mainCollectionView.collectionViewLayout = self.createLayout()
    }
    
    override func bind() {
        
        let input = GroupRoomViewModel.Input(
            viewDidLoad: Observable.just(Void())
        )
        
        let output = self.viewModel.transform(from: input)
        
        output.roomInfo
            .drive()
            .disposed(by: self.disposeBag)
    }
}

private extension GroupRoomViewController {
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
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150.0))
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
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 5)
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = .init(top: 26.0, leading: 0, bottom: 0, trailing: 0)

        return section
    }
    
    func createToDayQuestionCell() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        //section
        let section = NSCollectionLayoutSection(group: group)
//        section.boundarySupplementaryItems = [createSectionHeader(),createTodayQuestionSectionFooter()]
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        //section.visibleItemsInvalidationHandler = self.visibleItemsInvalidationHandler
        section.contentInsets = .init(top: 0, leading: 0, bottom: 15.0, trailing: 0)
        
        
        return section
    }
}

import SwiftUI
struct GroupRoomViewController_Priviews: PreviewProvider {
    static var previews: some View {
        Contatiner().edgesIgnoringSafeArea(.all)
    }
    struct Contatiner: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            let vc = GroupRoomViewController.create(with: GroupRoomViewModel(coordinator: DefaultGroupCoordinator(navigationController: UINavigationController())))
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        typealias UIViewControllerType =  UIViewController
    }
}
