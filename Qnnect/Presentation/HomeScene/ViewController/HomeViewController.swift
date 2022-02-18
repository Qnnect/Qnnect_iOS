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

final class HomeViewController: BaseViewController {
    
    private var viewModel: HomeViewModel!
    
    
    private let homeCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    ).then {
        $0.register(TitleCell.self, forCellWithReuseIdentifier: TitleCell.identifier)
        $0.register(TodayQuestionCell.self, forCellWithReuseIdentifier: TodayQuestionCell.identifier)
        $0.register(MyGroupCell.self, forCellWithReuseIdentifier: MyGroupCell.identifier)
        $0.register(HomeSectionHeaderView.self,forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,withReuseIdentifier: HomeSectionHeaderView.identifier)
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .p_ivory
    }
    
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
            self.pointImageView,
            self.pointLabel,
        ].forEach{
            self.pointView.addSubview($0)
        }
        
        self.view.addSubview(self.homeCollectionView)
        
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
        
        self.homeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(30.0)
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        self.homeCollectionView.collectionViewLayout = self.createLayout()
    }
    
    override func bind() {
        let dummyUser = User(profileImage: URL(string: "Abc"), name: "제제로")
        let content = "친구와 함께 가장 가고싶은 외국 여행지는 어디인가요? 글자수가 여기서 넘치면 마침표를 넣습니다넣습니다넣습니다넣..."
        let content1 = "우리중에 가장 I같은 사람은 누구일까요~?????"
        let dummyQuestions = [
            Question(groupName: "아아메 5인방 모임", d_day: "D-7", content: content),
            Question(groupName: "INFP 5인방 모임", d_day: "D-14", content: content1),
            Question(groupName: "아아메 5인방 모임", d_day: "D-7", content: content),
            Question(groupName: "아아메 5인방 모임", d_day: "D-7", content: content)
            ]
        let dummyGroups = [
            Group(name: "아아메 5인방 모임", createdDay: "2022.1.22~", headCount: 5),
            Group(name: "INFP 5인방 모임", createdDay: "2022.2.12~", headCount: 5),
            Group(name: "아아메 5인방 모임", createdDay: "2022.1.22~", headCount: 5),
            Group(name: "아아메 5인방 모임", createdDay: "2022.1.22~", headCount: 5),
            Group(name: "아아메 5인방 모임", createdDay: "2022.1.22~", headCount: 5),
            Group(name: "아아메 5인방 모임", createdDay: "2022.1.22~", headCount: 5),
        ]
        
        let user = Observable.just(dummyUser)
        let questions = Observable.just(dummyQuestions)
        let groups = Observable.just(dummyGroups)
        
        let datasource = self.createDataSource()
        Observable.combineLatest(user, questions, groups)
            .map { user,questions,groups -> [HomeSectionModel]in
                let titleItem = HomeSectionItem.titleSectionItem(user: user)
                let questionItem = questions.map { HomeSectionItem.todayQuestionSectionItem(question: $0) }
                let groupItem = groups.map { HomeSectionItem.mygroupSectionItem(group: $0)}
                return [
                    HomeSectionModel.titleSection(title: "", items: [titleItem]),
                    HomeSectionModel.todayQuestionSection(title: "오늘의 질문", items: questionItem),
                    HomeSectionModel.mygroupSection(title: "나의 그룹", items: groupItem)
                ]
            }.bind(to: self.homeCollectionView.rx.items(dataSource: datasource))
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
        item.contentInsets = .init(top: 10.0, leading: 5.0, bottom: 0, trailing: 5.0)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(60.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 5.0, bottom: 26.0, trailing: 5.0)
        
        return section
    }
    
    func createTodayQuestionLayout() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 10, bottom: 0, trailing: 10)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [createSectionHeader()]
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = .init(top: 0, leading: 5.0, bottom: 31.0, trailing: 10.0)
        
        return section
    }
    
    func createMyGroupLayout() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10.0, leading: 9.0, bottom: 10, trailing: 9.0)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(175.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [createSectionHeader()]
        section.contentInsets = .init(top: 0, leading: 5.0, bottom: 0, trailing: 5.0)
        
        return section
    }
    
    //SectionHeader layout설정
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
         
        //Section Header 사이즈
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60.0))
        
        //Section Header layout
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        
        return sectionHeader
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
            case.mygroupSectionItem(group: let group):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyGroupCell.identifier, for: indexPath) as! MyGroupCell
                cell.update(with: group)
                return cell
            }
        }configureSupplementaryView: { datasource, collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeSectionHeaderView.identifier, for: indexPath) as? HomeSectionHeaderView else  {
                    fatalError("Could not dequeReusableView")
                }
                let title = datasource.sectionModels[indexPath.section].title
                print("Section Title!!!\(title)")
                headerView.update(with: title)
                return headerView
            } else {
                return UICollectionReusableView()
            }
        }
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
