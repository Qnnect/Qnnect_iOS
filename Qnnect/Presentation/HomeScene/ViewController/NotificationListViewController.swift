//
//  NotificationListViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/22.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class NotificationListViewController: BaseViewController {
    
    private let navigationTitleLabel = NavigationTitleLabel(title: "알림")
    
    private var viewModel: NotificationListViewModel!
    weak var coordinator: HomeCoordinator?
    
    private let notiListTableView = UITableView().then {
        $0.backgroundColor = .p_ivory
    }
    
    static func create(
        with viewModel: NotificationListViewModel,
        _ coordinator: HomeCoordinator
    ) -> NotificationListViewController {
        let vc = NotificationListViewController()
        vc.viewModel = viewModel
        vc.coordinator = coordinator
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        
        view.addSubview(notiListTableView)
        
        notiListTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        navigationItem.titleView = navigationTitleLabel
    }
    
    override func bind() {
        super.bind()
        
        let input = NotificationListViewModel.Input(
            viewDidLoad: Observable.just(())
        )
        
        let output = viewModel.transform(from: input)
        
        output.notis
            .drive(onNext: {
                [weak self] _ in
                self?.notiListTableView.setEmptyView(message: "알림이 없어요")
            })
            .disposed(by: self.disposeBag)
    }
}
