//
//  SelectDrinkCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/20.
//

import UIKit

protocol SelectDrinkCoordinator: Coordinator {
    func start(_ cafeId: Int)
    func dismissDrinkSelectBottomSheet()
}

final class DefaultSelectDrinkCoordinator: SelectDrinkCoordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func start(_ cafeId: Int) {
        let drinkRepository = DefaultDrinkRepository(drinkNetworkService: DrinkNetworkService())
        let drinkUseCase = DefaultDrinkUseCase(drinkRepository: drinkRepository)
        let viewModel = DrinkSelctViewModel(drinkUseCase: drinkUseCase)
        let vc = DrinkSelectViewController.create(with: viewModel, cafeId, self)
        vc.modalPresentationStyle = .overCurrentContext
        if let vc = self.navigationController.presentedViewController as? DrinkSelectGuideAlertView {
            vc.dismiss(animated: false, completion: nil)
        }
        self.navigationController.present(vc, animated: false, completion: nil)
    }
    
    func dismissDrinkSelectBottomSheet() {
        if let vc = self.navigationController.presentedViewController as? BottomSheetViewController {
            vc.hideBottomSheetAndGoBack(nil)
        } 
    }
}
