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
        let useCase = DefaultLoginUseCase(authManager: DefaultAuthManager())
        let viewModel = LoginViewModel(loginUseCase: useCase)
        let vc = LoginViewController()
        vc.viewModel = viewModel
        self.navigationController.pushViewController(vc, animated: true)
    }
}
