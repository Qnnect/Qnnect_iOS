//
//  HomeCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/14.
//

import UIKit

protocol HomeCoordinator: Coordinator {
    func showAddGroupBottomSheet()
}

final class DefaultHomeCoordinator: HomeCoordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = HomeViewModel(coordinator: self)
        let vc = HomeViewController.create(with: viewModel)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showAddGroupBottomSheet() {
        let viewModel = AddGroupViewModel(
            coordinator: self,
            addGroupUseCase: DefaultAddGroupUseCase()
        )
        let vc = AddGroupViewController.create(with: viewModel)
        self.navigationController.present(vc, animated: true, completion: nil)
    }
}
