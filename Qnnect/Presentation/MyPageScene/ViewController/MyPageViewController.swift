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
        $0.showsVerticalScrollIndicator = false
    }
    
    private var viewModel: MyPageViewModel!
    weak var coordinator: MyPageCoordinator?
    
    static func create(
        with viewModel: MyPageViewModel,
        _ coordinator: MyPageCoordinator
    ) -> MyPageViewController {
        let vc = MyPageViewController()
        vc.viewModel = viewModel
        vc.coordinator = coordinator
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
        
        let items = Observable.just(MyPageItem.allCases)

        let input = MyPageViewModel.Input(
            didTapProfileCell: self.mainTableView.rx.itemSelected
                .filter{ $0.section == 0}
                .mapToVoid(),
            viewWillAppear: self.rx.viewWillAppear.mapToVoid(),
            viewDidLoad: Observable.just(()),
            didTapMyDrinkStampButton: rx.methodInvoked(#selector(pointCell))
                .filter {
                    let kind = $0[0] as! String
                    return kind == PointCell.myDrinkStamp
                }.mapToVoid(),
            didTapSendedQuestionButton: rx.methodInvoked(#selector(pointCell))
                .filter {
                    let kind = $0[0] as! String
                    return kind == PointCell.sendedQuestion
                }.mapToVoid(),
            didTapMyPagaItem: mainTableView.rx.modelSelected(MyPageSectionItem.self)
                .compactMap {
                    item -> MyPageItem? in
                    guard case let MyPageSectionItem.itemListSectionItem(myPageItem) = item else {
                        return nil
                    }
                    return myPageItem
                }
                .asObservable()
        )
        
        self.mainTableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        let output = self.viewModel.transform(from: input)
        
        let dataSource = self.createDataSource()
        Observable.combineLatest(output.user.asObservable(), items, output.loginType.asObservable())
            .map{ user, items, loginType -> [MyPageSectionModel] in
                let profileSectionItem = MyPageSectionItem.profileSectionItem(user: user,loginType:  loginType)
                let pointSectionItem = MyPageSectionItem.pointSectionItem(point: user.point)
                let myPageListSectionItem = items.map { MyPageSectionItem.itemListSectionItem(item: $0)}
                
                return [
                    MyPageSectionModel.profileSection(title: "", items: [profileSectionItem]),
                    MyPageSectionModel.pointSection(title: "", items: [pointSectionItem]),
                    MyPageSectionModel.itemListSection(title: "", items: myPageListSectionItem)
                ]
            }
            .debug()
            .bind(to: self.mainTableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        guard let coordinator = coordinator else { return }

        output.showEditProfileScene
            .emit(onNext: coordinator.showEditProfileScene(user:))
            .disposed(by: self.disposeBag)
        
        output.showMyDrinkStampButton
            .emit(onNext: coordinator.showMyDrinkStampScene)
            .disposed(by: self.disposeBag)
        
        output.showMyPageAlertView
            .emit(onNext: coordinator.showMyPageAlertView(myPageItem:))
            .disposed(by: self.disposeBag)
        
        output.showPersonalPolicy
            .emit(onNext: coordinator.showPersonalPolicy)
            .disposed(by: self.disposeBag)
        
        output.showTermsOfService
            .emit(onNext: coordinator.showTermsOfService)
            .disposed(by: self.disposeBag)
        
        output.showQnnectInstagram
            .emit(onNext: {
                 _ in
                let appURL = URL(string: APP.instagramAppURL)!
                let webURL = URL(string: APP.instagramWepURL)!
                if UIApplication.shared.canOpenURL(appURL) {
                    UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
                }
            }).disposed(by: self.disposeBag)
        
        output.showSendedQuestionListScene
            .emit(onNext: coordinator.showSentQuestionListScene)
            .disposed(by: self.disposeBag)
        
        output.showBloackedFriendListScene
            .emit(onNext: coordinator.showBlockedFriendListScene)
            .disposed(by: self.disposeBag)
        
    }
}

private extension MyPageViewController {
    func createDataSource() -> RxTableViewSectionedReloadDataSource<MyPageSectionModel> {
        return RxTableViewSectionedReloadDataSource<MyPageSectionModel> { datasource, tableView, indexPath, item in
            switch item {
            case let .profileSectionItem(user,loginType):
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifier, for: indexPath) as! ProfileCell
                cell.update(with: user,loginType)
                return cell
            case .pointSectionItem(let point):
                let cell = tableView.dequeueReusableCell(withIdentifier: PointCell.identifier, for: indexPath) as! PointCell
                cell.update(with: point)
                cell.delegate = self
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


extension MyPageViewController: PointCellDelegate {
    dynamic func pointCell(didTapButton kind: String) { }
}

