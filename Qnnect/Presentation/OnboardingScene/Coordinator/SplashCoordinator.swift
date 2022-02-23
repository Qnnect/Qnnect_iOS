//
//  SplashCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import UIKit

protocol SplashCoordinator: Coordinator {
    func showOnboarding()
    func showLogin()
    func showMain()
}

final class DefaultSplashCoordinator: SplashCoordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let repository =  DefaultAuthRepository(
            localStorage: DefaultUserDefaultManager(),
            authNetworkManager: AuthNetworkManager()
        )
        let useCase = DefaultLoginUseCase(authRepository: repository)
        let viewModel = SplashViewModel(
            coordinator: self,
            loginUseCase: useCase
        )
        let vc = SplashViewController.create(with: viewModel)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showOnboarding() {
        print("showOnboarding call!!")
        let vc = OnboardingViewController.create()
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showLogin() {
        
    }
    
    func showMain() {
        
    }
}
