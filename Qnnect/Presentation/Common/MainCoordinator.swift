//
//  MainCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/14.
//

import Foundation
import UIKit

protocol MainCoordinator: Coordinator {
    
}

final class DefaultMainCoordinator: MainCoordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    private var tabbarController: UITabBarController
    init(
        navigationController: UINavigationController,
        tabbarController: UITabBarController
    ) {
        self.navigationController = navigationController
        self.tabbarController = tabbarController
    }
    func start() {
        
    }
}
