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
            authNetworkService: AuthNetworkService()
        )
        let useCase = DefaultAuthUseCase(authRepository: repository)
        let viewModel = SplashViewModel(authUseCase: useCase)
        let vc = SplashViewController.create(with: viewModel, self)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showOnboarding() {
        let viewModel = OnboardingViewModel()
        let vc = OnboardingViewController.create(with: viewModel, self)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showLogin() {
        let coordinator = DefaultAuthCoordinator(navigationController: self.navigationController)
        coordinator.start()
        self.parentCoordinator?.childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self.parentCoordinator
        self.parentCoordinator?.childCoordinators.removeAll(where: { $0 === self })
    }
    
    func showMain() {
        let coordinator = DefaultMainCoordinator(navigationController: self.navigationController, tabbarController: UITabBarController())
        coordinator.start()
        self.parentCoordinator?.childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self.parentCoordinator
        self.parentCoordinator?.childCoordinators.removeAll(where: { $0 === self })
    }
}
