//
//  MainCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/14.
//

import Foundation
import UIKit

protocol MainCoordinator: Coordinator { }

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
        let viewControllers: [UIViewController] = TabbarItem.allCases.map {
            let coordinator = $0.coordinator
            let vc = coordinator.navigationController
            self.childCoordinators.append(coordinator)
            coordinator.start()
            vc.tabBarItem = UITabBarItem(
                title: $0.title,
                image: $0.icon.default,
                selectedImage: $0.icon.selected
            )
            return vc
        }
        self.tabbarController.tabBar.layer.borderWidth = 1.0
        self.tabbarController.tabBar.layer.borderColor = UIColor.brownBorderColor?.cgColor
        self.tabbarController.viewControllers = viewControllers
        self.navigationController.pushViewController(tabbarController, animated: true)
    }
}
