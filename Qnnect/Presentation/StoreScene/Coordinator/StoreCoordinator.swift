//
//  StoreCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/16.
//

import UIKit
import RxSwift

protocol StoreCoordinator: Coordinator {
    func showIngredientBuyAlertView(with ingredient: Ingredient)
    func showNotBuyAlertView()
    func showIngredientStorageScene()
    func dismissIngredientBuyAlertView()
}

final class DefaultStoreCoordinator: StoreCoordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let storeRepository = DefaultStoreRepository(storeNetworkService: StoreNetworkService())
        let storeUseCase = DefaultStoreUseCase(storeRepository: storeRepository)
        let viewModel = StoreViewModel(storeUseCase: storeUseCase)
        let vc = StoreViewController.create(with: viewModel, self)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showIngredientBuyAlertView(with ingredient: Ingredient) {
        let storeRepository = DefaultStoreRepository(storeNetworkService: StoreNetworkService())
        let storeUseCase = DefaultStoreUseCase(storeRepository: storeRepository)
        let viewModel = IngredientBuyAlertViewModel(storeUseCase: storeUseCase)
        let vc = IngredientBuyAlertViewController.create(with: ingredient, viewModel, self)
        vc.modalPresentationStyle = .overCurrentContext
        self.navigationController.present(vc, animated: true,completion: nil)
    }
    
    func showNotBuyAlertView() {
        let notBuyAlertview = NotBuyAlertViewController.create()
        if let view = self.navigationController.presentedViewController as? IngredientBuyAlertViewController {
            view.dismiss(animated: false) {
                [weak self] in
                notBuyAlertview.modalPresentationStyle = .overCurrentContext
                self?.navigationController.present(notBuyAlertview, animated: true, completion: nil)
            }
        }
    }
    
    func showIngredientStorageScene() {
        let storeRepository = DefaultStoreRepository(storeNetworkService: StoreNetworkService())
        let storeUseCase = DefaultStoreUseCase(storeRepository: storeRepository)
        let viewModel = IngredientStorageViewModel(storeUseCase: storeUseCase)
        let vc = IngredientStorageViewController.create(with: viewModel, self)
        navigationController.pushViewController(vc, animated: true)
    }
    func dismissIngredientBuyAlertView() {
        if let vc =  self.navigationController.presentedViewController as? IngredientBuyAlertViewController {
            vc.dismiss(animated: true, completion: nil)
        }
    }
}
