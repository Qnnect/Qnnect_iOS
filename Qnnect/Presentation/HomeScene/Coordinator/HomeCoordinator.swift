//
//  HomeCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/14.
//

import UIKit

protocol HomeCoordinator: Coordinator {
    func showAddGroupBottomSheet()
    func showGroupScene()
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
        let cafeRepository = DefaultCafeRepository(cafeNetworkService: CafeNetworkService())
        let addGroupUseCase = DefaultAddCafeUseCase(cafeRepository: cafeRepository)
        let viewModel = AddCafeViewModel(
            coordinator: self,
            addGroupUseCase: addGroupUseCase
        )
        let vc = AddCafeViewController.create(with: viewModel)
        vc.modalPresentationStyle = .overCurrentContext
        self.navigationController.present(vc, animated: false, completion: nil)
    }
    
    func showGroupScene() {
        let coordinator = DefaultGroupCoordinator(navigationController: self.navigationController)
        coordinator.parentCoordinator = self
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
 
}
