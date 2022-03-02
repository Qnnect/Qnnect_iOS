//
//  LoginCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/10.
//

import UIKit

protocol AuthCoordinator: Coordinator {
    func showSetProfileScene(token: Token, isAgreedNoti: Bool)
    func showTermsVC(token: Token)
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
            authNetworkService: AuthNetworkService()
        )
        let useCase = DefaultAuthUseCase(authRepository: repository)
        let viewModel = LoginViewModel(
            coordinator: self,
            authUseCase: useCase
        )
        let vc = LoginViewController.create(with: viewModel)
        let socialLoginManager = SocialLoginManager(vc: vc)
        viewModel.socialLoginManager = socialLoginManager
        self.navigationController.pushViewController(vc, animated: true)
        self.navigationController.viewControllers.removeAll { $0 != vc }
    }
    
    func showSetProfileScene(token: Token, isAgreedNoti: Bool) {
        let inputUseCase = DefaultInputUseCase()
        let viewModel = SetProfileViewModel(
            coordinator: self,
            inputUseCase: inputUseCase
        )
        let vc = SetProfileViewController.create(with: viewModel, token, isAgreedNoti)
        let socialLoginManager = SocialLoginManager(vc: vc)
        viewModel.authManager = socialLoginManager
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showTermsVC(token: Token) {
        let inputUseCase = DefaultInputUseCase()
        let viewModel = TermsViewModel(
            coordinator: self,
            inputUseCase: inputUseCase
        )
        let vc = TermsViewController.create(with: viewModel,token)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showMain() {
        //TODO: 탭바 세팅, push HomeVC
        self.navigationController.isNavigationBarHidden = true
        let coordinator = DefaultMainCoordinator(navigationController: self.navigationController, tabbarController: UITabBarController())
        self.parentCoordinator?.childCoordinators.append(coordinator)
        coordinator.start()
        self.parentCoordinator?.childCoordinators.remove(at: 0)
    }
}
