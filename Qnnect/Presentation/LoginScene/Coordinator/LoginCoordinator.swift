//
//  LoginCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/10.
//

import UIKit


final class LoginCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = LoginViewController()
        let loginManager = LoginManager(vc: vc)
        let viewModel = LoginViewModel(loginManager: loginManager)
        vc.viewModel = viewModel
        self.navigationController.pushViewController(vc, animated: true)
    }
}
