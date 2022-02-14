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
        let viewModel = LoginViewModel(coordinator: self)
        let vc = LoginViewController.create(with: viewModel)
        let loginManager = LoginManager(vc: vc)
        viewModel.loginManager = loginManager
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showInputNameVC() {
        let inputUseCase = DefaultInputUseCase()
        let viewModel = InputNameViewModel(coordinator: self, inputUseCase: inputUseCase)
        let vc = InputNameViewController.create(with: viewModel)
        self.navigationController.pushViewController(vc, animated: true)
    }
}
