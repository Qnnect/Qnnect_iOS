//
//  HomeCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/14.
//

import UIKit

protocol HomeCoordinator: Coordinator {
    func showAddGroupBottomSheet()
    func showGroupScene(with cafeId: Int, _ isFirst: Bool)
}

final class DefaultHomeCoordinator: HomeCoordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeRepository = DefaultHomeRepository(homeNetworkService: HomeNetworkService())
        let homeUseCase = DefaultHomeUseCase(homeRepository: homeRepository)
        let viewModel = HomeViewModel(coordinator: self, homeUseCase: homeUseCase)
        let vc = HomeViewController.create(with: viewModel)
        self.navigationController.pushViewController(vc, animated: true)
        self.navigationController.viewControllers.removeAll { $0 != vc }
    }
    
    func showAddGroupBottomSheet() {
        let cafeRepository = DefaultCafeRepository(cafeNetworkService: CafeNetworkService())
        let cafeUseCase = DefaultCafeUseCase(cafeRepository: cafeRepository)
        let viewModel = AddCafeViewModel(
            coordinator: self,
            cafeUseCase: cafeUseCase
        )
        let vc = AddCafeViewController.create(with: viewModel)
        vc.modalPresentationStyle = .overCurrentContext
        self.navigationController.present(vc, animated: false, completion: nil)
    }
    
    func showGroupScene(with cafeId: Int, _ isFirst: Bool = false) {
        let coordinator = DefaultGroupCoordinator(navigationController: self.navigationController)
        coordinator.parentCoordinator = self
        self.childCoordinators.append(coordinator)
        coordinator.start(with: cafeId,isFirst)
    }
 
}
