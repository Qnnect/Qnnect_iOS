//
//  GroupCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/28.
//

import Foundation
import UIKit

protocol CafeCoordinator: Coordinator {
    func showSelectDrinkBottomSheet()
    func start(with cafeId: Int)
    func showDrinkSelectGuideAlertView(_ type: UserBehaviorType)
    func dismissAlert()
}

final class DefaultGroupCoordinator: CafeCoordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func start(with cafeId: Int) {
        let cafeRepository = DefaultCafeRepository(cafeNetworkService: CafeNetworkService())
        let cafeUseCase = DefaultCafeUseCase(cafeRepository: cafeRepository)
        let viewModel = CafeRoomViewModel(
            coordinator: self,
            cafeUseCase: cafeUseCase
        )
        let vc = CafeRoomViewController.create(with: viewModel,cafeId)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showSelectDrinkBottomSheet() {
        let vc = SelectDrinkViewController.create()
        vc.modalPresentationStyle = .overCurrentContext
        
        if let vc = self.navigationController.presentedViewController {
            vc.dismiss(animated: false, completion: nil)
        }
        self.navigationController.present(vc, animated: false, completion: nil)
    }
    
    func showDrinkSelectGuideAlertView(_ type: UserBehaviorType) {
        let viewModel = DrinkSelectGuideAlertViewModel(coordinator: self)
        let alert = DrinkSelectGuideAlertView.create(with: viewModel, type)
        alert.modalPresentationStyle = .overCurrentContext
        self.navigationController.present(alert, animated: true, completion: nil)
    }
    
    func dismissAlert() {
        self.navigationController.presentedViewController?.dismiss(animated: true, completion: nil)
    }
}
