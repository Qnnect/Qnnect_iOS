//
//  HomeCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/14.
//

import UIKit

protocol HomeCoordinator: Coordinator {
    func showAddGroupBottomSheet()
    func showSelectDrinkBottomSheet()
}

final class DefaultHomeCoordinator: HomeCoordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = HomeViewModel(coordinator: self)
        let vc = HomeViewController.create(with: viewModel)
        self.navigationController.pushViewController(vc, animated: true)
        self.navigationController.viewControllers.removeAll { $0 != vc }
    }
    
    func showAddGroupBottomSheet() {
        let viewModel = AddGroupViewModel(
            coordinator: self,
            addGroupUseCase: DefaultAddGroupUseCase()
        )
        let vc = AddGroupViewController.create(with: viewModel)
        vc.modalPresentationStyle = .overCurrentContext
        self.navigationController.present(vc, animated: false, completion: nil)
    }
    
    func showSelectDrinkBottomSheet() {
        let vc = SelectDrinkViewController.create()
        vc.modalPresentationStyle = .overCurrentContext
        self.navigationController.presentedViewController?.dismiss(animated: false, completion: nil)
        self.navigationController.present(vc, animated: false, completion: nil)
    }
}
