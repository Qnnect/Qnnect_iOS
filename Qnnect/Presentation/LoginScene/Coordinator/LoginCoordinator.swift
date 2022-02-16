//
//  LoginCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/10.
//

import UIKit

protocol LoginCoordinator: Coordinator {
    func showInputNameVC()
    func showTermsVC()
    func showHomeVC()
}
final class DefaultLoginCoordinator: LoginCoordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = LoginViewModel(coordinator: self)
        let vc = LoginViewController.create(with: viewModel)
        let authManager = AuthManager(vc: vc)
        viewModel.authManager = authManager
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showInputNameVC() {
        let signUpUseCase = DefaultSignUpUseCase()
        let viewModel = SetProfileViewModel(
            coordinator: self,
            inputUseCase: signUpUseCase
        )
        let vc = SetProfileViewController.create(with: viewModel)
        let authManager = AuthManager(vc: vc)
        viewModel.authManager = authManager
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showTermsVC() {
        let signUpUseCase = DefaultSignUpUseCase()
        let viewModel = TermsViewModel(
            coordinator: self,
            signUpUseCase: signUpUseCase
        )
        let vc = TermsViewController.create(with: viewModel)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showHomeVC() {
        //TODO: 탭바 세팅, push HomeVC

    }
}
