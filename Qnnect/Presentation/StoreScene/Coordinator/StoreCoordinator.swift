//
//  StoreCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/16.
//

import UIKit

protocol StoreCoordinator: Coordinator { }

final class DefaultStoreCoordinator: StoreCoordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let viewModel = StoreViewModel(coordinator: self)
        let vc = StoreViewController.create(with: viewModel)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
}
