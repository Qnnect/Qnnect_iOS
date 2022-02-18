//
//  HomeViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/14.
//

import UIKit
import SnapKit
import Then

final class HomeViewController: BaseViewController {
    
    private var viewModel: HomeViewModel!
    
    
//    private let mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
//        $0.back
//    }
    
    private let pointImageView = UIImageView().then {
        $0.image = Constants.pointImage
        $0.contentMode = .scaleAspectFit
    }
    
    private let pointLabel = UILabel().then {
        $0.text = "500P"
        $0.font = .BM_JUA(size: 18.0)
        $0.textColor = .BLACK_121212
    }
    
    private let pointView = UIView().then {
        $0.backgroundColor = .p_ivory
    }
    
    
    static func create(with viewModel: HomeViewModel) -> HomeViewController {
        let vc = HomeViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
        [
            pointImageView,
            pointLabel
        ].forEach{
            self.pointView.addSubview($0)
        }
        
        self.view.backgroundColor = .p_ivory
        
        //navigation Item
        self.navigationItem.leftBarButtonItems = [
            Constants.navigationLeftPadding,
            UIBarButtonItem(customView: self.pointView)
        ]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Constants.notificationIcon, style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        
        self.pointImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        self.pointLabel.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.equalTo(self.pointImageView.snp.trailing).offset(8.0)
        }
        
    }
    
    override func bind() {
        
    }
}

// MARK: - CollectionView CompositionLayout
extension HomeViewController {
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
        item.contentInsets = .init(top: 10, leading: 5, bottom: 0, trailing: 5)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(60.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        return section
    }
    
    func createTodayQuestionLayout() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(0.9))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 5, bottom: 0, trailing: 5)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(170.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        return section
    }
    
    func createMyGroupLayout() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.75))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 5, bottom: 0, trailing: 5)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(175.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        return section
    }
    
}

import SwiftUI
struct HomeViewController_Priviews: PreviewProvider {
    static var previews: some View {
        Contatiner().edgesIgnoringSafeArea(.all)
    }
    struct Contatiner: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            let vc = HomeViewController() //보고 싶은 뷰컨 객체
            return UINavigationController(rootViewController: vc)
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        typealias UIViewControllerType =  UIViewController
    }
}
