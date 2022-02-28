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
        let viewModel = StoreViewModel(coordinator: self)
        let vc = StoreViewController.create(with: viewModel)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showIngredientBuyAlertView(with ingredient: Ingredient) {
        let viewModel = IngredientBuyAlertViewModel(
            coordinator: self
        )
        let vc = IngredientBuyAlertViewController.create(with: ingredient, viewModel)
        vc.modalPresentationStyle = .overCurrentContext
        self.navigationController.present(vc, animated: true,completion: nil)
    }
    
    func dismissIngredientBuyAlertView() {
        if let vc =  self.navigationController.presentedViewController as? IngredientBuyAlertViewController {
            vc.dismiss(animated: true, completion: nil)
        }
    }
}
