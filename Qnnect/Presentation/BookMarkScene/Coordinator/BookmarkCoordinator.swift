//
//  BookmarkCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/16.
//

import Foundation
import UIKit


protocol BookmarkCoordinator: Coordinator { }

final class DefaultBookmarkCoordinator: BookmarkCoordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = BookmarkViewModel(coordinator: self)
        let vc = BookmarkViewController.create(with: viewModel)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
}
