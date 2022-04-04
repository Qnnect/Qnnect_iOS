//
//  AppCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/10.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = [] {
        didSet {
            print("AppCoordinator ChildCoordinators : \(childCoordinators)")
        }
    }
    
    var navigationController: UINavigationController
    
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    /// Splash Scene Start!!!
    func start() {
        let coordinator = DefaultSplashCoordinator(navigationController: self.navigationController)
        self.childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func startInviteFlow(_ inviteCode: String) {
        let coordinator = DefaultSplashCoordinator(navigationController: self.navigationController)
        self.childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start(inviteCode: inviteCode)
    }
    
    func startPushNoti() {
        let coordinator = DefaultSplashCoordinator(navigationController: self.navigationController)
        self.childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start(didTapPushNoti: true)
    }
    
}
