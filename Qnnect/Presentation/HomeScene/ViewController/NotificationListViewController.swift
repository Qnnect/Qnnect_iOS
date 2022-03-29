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
        $0.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.identifier)
        $0.showsVerticalScrollIndicator = false
        $0.separatorInsetReference = .fromCellEdges
        $0.separatorInset = .init(top: 0, left: 23.0, bottom: 0, right: 23.0)
        $0.estimatedRowHeight = UITableView.automaticDimension
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
    
    private var curPage = 0
    private var isFetched = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        
        view.addSubview(notiListTableView)
        
        notiListTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        notiListTableView.delegate = self
        
        navigationItem.titleView = navigationTitleLabel
    }
    
    override func bind() {
        super.bind()
        
        let input = NotificationListViewModel.Input(
            viewDidLoad: Observable.just(()),
            moreFetch: rx.methodInvoked(#selector(fetchMore))
                .map{ $0[0] as! Int}
        )
        
        let output = viewModel.transform(from: input)
        
        output.notis
            .do {
                [weak self] notis in
                if notis.isEmpty {
                    self?.notiListTableView.setEmptyView(message: "알림이 없어요.")
                } else {
                    self?.notiListTableView.reset()
                }
            }
            .drive(notiListTableView.rx.items(
                cellIdentifier: NotificationCell.identifier, cellType: NotificationCell.self
            ))({ index, model, cell in
                cell.update(with: model)
            })
            .disposed(by: self.disposeBag)
        
        output.canLoad
            .emit(onNext: {
                [weak self] flag in
                if flag {
                    self?.isFetched = true
                }
            }).disposed(by: self.disposeBag)
        
    }
}

extension NotificationListViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == notiListTableView else { return }
        
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.size.height {
            if(isFetched){
                isFetched = false
                curPage += 1
                fetchMore(curPage)
            }
        }
    }
    
    @objc dynamic func fetchMore(_ page: Int) {
        
    }
}
