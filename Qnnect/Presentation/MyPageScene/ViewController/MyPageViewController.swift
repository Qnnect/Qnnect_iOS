//
//  MyPageViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/16.
//

import UIKit
import SnapKit
import Then
import RxDataSources
import RxSwift

final class MyPageViewController: BaseViewController {
    
    private var viewModel: MyPageViewModel!
    
    private let navigationTitleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 18.0)
        $0.textColor = .GRAY01
        $0.text = "마이페이지"
    }
    
    private let mainTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.identifier)
        $0.register(PointCell.self, forCellReuseIdentifier: PointCell.identifier)
        $0.register(MyPageItemCell.self, forCellReuseIdentifier: MyPageItemCell.identifier)
        $0.separatorStyle = .none
    }
    static func create(with viewModel: MyPageViewModel) -> MyPageViewController {
        let vc = MyPageViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
        self.view.addSubview(self.mainTableView)
        self.view.backgroundColor = .p_ivory
        
        //navigation
        self.navigationItem.leftBarButtonItems = [
            Constants.navigationLeftPadding,
            UIBarButtonItem(customView: self.navigationTitleLabel)
        ]
        self.navigationController?.navigationBar.barTintColor = self.view.backgroundColor
        
        self.mainTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalToSuperview()
        }
        
        self.mainTableView.backgroundColor = self.view.backgroundColor
    }
    
    override func bind() {
        
        let dummyUser = Observable.just(User(name: "", point: 500, profileImage: ""))
        let dummyPoint = Observable.just(500)
        let items = Observable.just(MyPageItem.allCases)
        
        let dataSource = self.createDataSource()
        Observable.combineLatest(dummyUser, dummyPoint, items)
            .map{ user,point,items -> [MyPageSectionModel] in
                let profileSectionItem = MyPageSectionItem.profileSectionItem(user: user)
                let pointSectionItem = MyPageSectionItem.pointSectionItem(point: point)
                let myPageListSectionItem = items.map { MyPageSectionItem.itemListSectionItem(item: $0)}
                
                return [
                    MyPageSectionModel.profileSection(title: "", items: [profileSectionItem]),
                    MyPageSectionModel.pointSection(title: "", items: [pointSectionItem]),
                    MyPageSectionModel.itemListSection(title: "", items: myPageListSectionItem)
                ]
            }
            .bind(to: self.mainTableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        

        let input = MyPageViewModel.Input(didTapProfileCell: self.mainTableView.rx.itemSelected
                                            .filter{ $0.section == 0}
                                            .mapToVoid()
        )
        
        self.mainTableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        let output = self.viewModel.transform(from: input)
        
        output.showEditProfileScene
            .emit()
            .disposed(by: self.disposeBag)
    }
}

private extension MyPageViewController {
    func createDataSource() -> RxTableViewSectionedReloadDataSource<MyPageSectionModel> {
        return RxTableViewSectionedReloadDataSource<MyPageSectionModel> { datasource, tableView, indexPath, item in
            switch item {
            case .profileSectionItem(let user):
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifier, for: indexPath) as! ProfileCell
                cell.update(with: user)
                return cell
            case .pointSectionItem(let point):
                let cell = tableView.dequeueReusableCell(withIdentifier: PointCell.identifier, for: indexPath) as! PointCell
                cell.update(with: point)
                return cell
            case .itemListSectionItem(let item):
                let cell = tableView.dequeueReusableCell(withIdentifier: MyPageItemCell.identifier, for: indexPath) as! MyPageItemCell
                cell.update(with: item)
                return cell
            }
        }titleForHeaderInSection: { _, _ in
            return "  "
        }titleForFooterInSection: { _, _ in
            return " "
        }
    }
}

extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 20.0
        case 1:
            return 25.0
        case 2:
            return 26.0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

import SwiftUI
struct MyPageViewController_Priviews: PreviewProvider {
    static var previews: some View {
        Contatiner().edgesIgnoringSafeArea(.all)
    }
    struct Contatiner: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            let vc = MyPageViewController.create(with: MyPageViewModel(coordinator: DefaultMyPageCoordinator(navigationController: UINavigationController()))) //보고 싶은 뷰컨 객체
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        typealias UIViewControllerType =  UIViewController
    }
}

