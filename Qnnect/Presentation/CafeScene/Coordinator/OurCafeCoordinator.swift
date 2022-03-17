//
//  OurCafeCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/17.
//

import UIKit

protocol OurCafeCoordinator: Coordinator {
    func start(cafeId: Int, cafeUserId: Int)
}

final class DefaultOurCafeCoordinator: OurCafeCoordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func start(cafeId: Int, cafeUserId: Int) {
        let ourCafeRepository = DefaultOurCafeRepository(ourCafeNetworkService: OurCafeNetworkService())
        let ourCafeUseCase = DefaultOurCafeUseCase(ourCafeRepository: ourCafeRepository)
        let viewModel = OurCafeViewModel(ourCafeUseCase: ourCafeUseCase)
        let vc = OurCafeViewController.create(
            with: viewModel,
            self,
            cafeId: cafeId,
            cafeUserId: cafeUserId
        )
        navigationController.pushViewController(vc, animated: true)
        navigationController.tabBarController?.tabBar.isHidden = true
    }
}
