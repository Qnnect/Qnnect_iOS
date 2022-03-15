//
//  LoginCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/10.
//

import UIKit

protocol AuthCoordinator: Coordinator {
    func showSetProfileScene(token: Token, isAgreedNoti: Bool, loginType: LoginType)
    func showTermsVC(token: Token, loginType: LoginType)
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
        let viewModel = LoginViewModel(authUseCase: useCase)
        let vc = LoginViewController.create(with: viewModel,self)
        let socialLoginManager = SocialLoginManager(vc: vc)
        viewModel.socialLoginManager = socialLoginManager
        self.navigationController.pushViewController(vc, animated: true)
        self.navigationController.viewControllers.removeAll { $0 != vc }
    }
    
    func showSetProfileScene(token: Token, isAgreedNoti: Bool, loginType: LoginType) {
        let authUseCase = DefaultAuthUseCase(authRepository: DefaultAuthRepository(localStorage: DefaultUserDefaultManager(), authNetworkService: AuthNetworkService()))
        let userRepository = DefaultUserRepositry(
            userNetworkService: UserNetworkService(),
            localStorage: DefaultUserDefaultManager()
        )
        let userUseCase = DefaultUserUseCase(userRepository: userRepository)
        let viewModel = SetProfileViewModel(
            authUseCase: authUseCase,
            userUseCase: userUseCase
        )
        let vc = SetProfileViewController.create(with: viewModel, token, isAgreedNoti, loginType,self)
        let socialLoginManager = SocialLoginManager(vc: vc)
        viewModel.authManager = socialLoginManager
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showTermsVC(token: Token, loginType: LoginType) {
        let authUseCase = DefaultAuthUseCase(authRepository: DefaultAuthRepository(localStorage: DefaultUserDefaultManager(), authNetworkService: AuthNetworkService()))
        let viewModel = TermsViewModel(authUseCase: authUseCase)
        let vc = TermsViewController.create(with: viewModel,token,loginType,self)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showMain() {
        //TODO: 탭바 세팅, push HomeVC
        self.navigationController.isNavigationBarHidden = true
        let coordinator = DefaultMainCoordinator(navigationController: self.navigationController, tabbarController: TabBarController())
        self.parentCoordinator?.childCoordinators.append(coordinator)
        coordinator.start()
        self.parentCoordinator?.childCoordinators.remove(at: 0)
    }
}
