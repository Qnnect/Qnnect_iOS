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
}

final class DefaultGroupCoordinator: CafeCoordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = GroupRoomViewModel(
            coordinator: self
        )
        let vc = CafeRoomViewController.create(with: viewModel)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func start(with cafeId: Int) {
        let viewModel = GroupRoomViewModel(
            coordinator: self,
            
        )
        let vc = CafeRoomViewController.create(with: viewModel)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showSelectDrinkBottomSheet() {
        let vc = SelectDrinkViewController.create()
        vc.modalPresentationStyle = .overCurrentContext
        self.navigationController.present(vc, animated: false, completion: nil)
    }
}
