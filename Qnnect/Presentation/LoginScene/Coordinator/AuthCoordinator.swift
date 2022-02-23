//
//  LoginCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/10.
//

import UIKit

protocol AuthCoordinator: Coordinator {
    func showInputNameVC()
    func showTermsVC()
    func showMain()
}
final class DefaultAuthCoordinator: AuthCoordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let repository = DefaultAuthRepository(
            localStorage: DefaultUserDefaultManager(),
            authNetworkManager: AuthNetworkManager()
        )
        let useCase = DefaultLoginUseCase(authRepository: repository)
        let viewModel = LoginViewModel(
            coordinator: self,
            loginUseCase: useCase
        )
        let vc = LoginViewController.create(with: viewModel)
        let socialLoginManager = SocialLoginManager(vc: vc)
        viewModel.socialLoginManager = socialLoginManager
        self.navigationController.pushViewController(vc, animated: true)
        self.navigationController.viewControllers.removeAll { $0 != vc }
    }
    
    func showInputNameVC() {
        let signUpUseCase = DefaultSignUpUseCase()
        let viewModel = SetProfileViewModel(
            coordinator: self,
            signUpUseCase: signUpUseCase
        )
        let vc = SetProfileViewController.create(with: viewModel)
        let socialLoginManager = SocialLoginManager(vc: vc)
        viewModel.authManager = socialLoginManager
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
    
    func showMain() {
        //TODO: 탭바 세팅, push HomeVC
        let coordinator = DefaultMainCoordinator(navigationController: self.navigationController, tabbarController: UITabBarController())
        self.parentCoordinator?.childCoordinators.append(coordinator)
        coordinator.start()
        self.parentCoordinator?.childCoordinators.remove(at: 0)
    }
}
