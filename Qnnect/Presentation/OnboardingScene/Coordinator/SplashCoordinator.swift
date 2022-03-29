//
//  SplashCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import UIKit

protocol SplashCoordinator: Coordinator {
    func showOnboarding(_ inviteCode: String?)
    func showLogin(_ inviteCode: String?)
    func showMain(_ inviteCode: String?)
}

extension SplashCoordinator {
    func showLogin(_ inviteCode: String? = nil) {
        showLogin(inviteCode)
    }
    
    func showOnboarding(_ inviteCode: String? = nil) {
        showOnboarding(inviteCode)
    }

    func showMain(_ inviteCode: String? = nil) {
        showMain(inviteCode)
    }
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
        let vc = SplashViewController.create(with: viewModel, self, nil)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func start(inviteCode: String?) {
        print("inviteCode \(inviteCode)")
        let repository =  DefaultAuthRepository(
            localStorage: DefaultUserDefaultManager(),
            authNetworkService: AuthNetworkService()
        )
        let useCase = DefaultAuthUseCase(authRepository: repository)
        let viewModel = SplashViewModel(authUseCase: useCase)
        let vc = SplashViewController.create(with: viewModel, self, inviteCode)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showOnboarding(_ inviteCode: String?) {
        let viewModel = OnboardingViewModel()
        let vc = OnboardingViewController.create(with: viewModel, self, inviteCode)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showLogin(_ inviteCode: String?) {
        let coordinator = DefaultAuthCoordinator(navigationController: self.navigationController)
        self.parentCoordinator?.childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self.parentCoordinator
        coordinator.start(inviteCode: inviteCode)
        self.parentCoordinator?.childCoordinators.removeAll(where: { $0 === self })
    }
    
    func showMain(_ inviteCode: String?) {
        print("show Main inviteCode \(inviteCode)")
        let coordinator = DefaultMainCoordinator(navigationController: self.navigationController, tabbarController: UITabBarController())
        self.parentCoordinator?.childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self.parentCoordinator
        coordinator.start(inviteCode: inviteCode)
        self.parentCoordinator?.childCoordinators.removeAll(where: { $0 === self })
    }
}
