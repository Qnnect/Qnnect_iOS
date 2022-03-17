//
//  StorageCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/18.
//

import UIKit

protocol StorageCoordinator: Coordinator { }

final class DefaultStorageCoordinator: StorageCoordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let storeRepository = DefaultStoreRepository(storeNetworkService: StoreNetworkService())
        let storeUseCase = DefaultStoreUseCase(storeRepository: storeRepository)
        let viewModel = IngredientStorageViewModel(storeUseCase: storeUseCase)
        let vc = IngredientStorageViewController.create(with: viewModel, self)
        navigationController.pushViewController(vc, animated: true)
    }
}
