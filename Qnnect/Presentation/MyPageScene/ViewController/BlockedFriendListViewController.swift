//
//  BlockedFriendListViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/24.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class BlockFriendListViewController: BaseViewController {
    
    private let navigationTitleLabel = NavigationTitleLabel(title: "신고/차단친구 관리")
    
    private let mainTableView = UITableView().then {
        $0.backgroundColor = .p_ivory
        $0.register(BlockedFriendCell.self, forCellReuseIdentifier: BlockedFriendCell.identifier)
        $0.separatorStyle = .none
    }
    
    private var viewModel: BlockedFriendListViewModel!
    weak var coordinator: MyPageCoordinator?
    
    static func create(
        with viewModel: BlockedFriendListViewModel,
        _ coordinator: MyPageCoordinator
    ) -> BlockFriendListViewController {
        let vc = BlockFriendListViewController()
        vc.viewModel = viewModel
        vc.coordinator = coordinator
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        
        view.addSubview(mainTableView)
        
        mainTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        navigationItem.titleView = navigationTitleLabel
    }
    
    override func bind() {
        super.bind()
        
        let input = BlockedFriendListViewModel.Input(
            viewDidLoad: Observable.just(()),
            didTapRelease: rx.methodInvoked(#selector(didTapReleaseButton(didTap:reportId:)))
                .map({ $0[1] as! Int })
        )
        
        let output = viewModel.transform(from: input)
        
        output.blockedFriends
            .debug()
            .do {
                [weak self] friends in
                if friends.isEmpty {
                    self?.mainTableView.setEmptyView(message: "신고/차단된 친구가 없습니다.")
                } else {
                    self?.mainTableView.reset()
                }
            }.drive(mainTableView.rx.items(
                cellIdentifier: BlockedFriendCell.identifier,
                cellType: BlockedFriendCell.self
            )) {
                [weak self] index, model, cell in
                guard let self = self else { return }
                cell.update(with: model)
                cell.delegate = self
            }.disposed(by: self.disposeBag)
        
    
    }
}

extension BlockFriendListViewController: BlockedFriendCellDelegate {
    func didTapReleaseButton(didTap cell: UITableViewCell, reportId: Int) {
    }
}


