//
//  MyPageCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/16.
//

import UIKit

protocol MyPageCoordinator: Coordinator { }

final class DefaultMyPageCoordinator: MyPageCoordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = MyPageViewModel(coordinator: self)
        let vc = MyPageViewController.create(with: viewModel)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
}
