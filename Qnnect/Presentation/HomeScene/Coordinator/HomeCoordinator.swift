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
    func showJoinCafeBottomSheet()
    func showCafeQuestionScene(_ questionId: Int)
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
        let viewModel = HomeViewModel(homeUseCase: homeUseCase)
        let vc = HomeViewController.create(with: viewModel, self)
        self.navigationController.pushViewController(vc, animated: true)
        self.navigationController.viewControllers.removeAll { $0 != vc }
    }
    
    func showAddGroupBottomSheet() {
        let cafeRepository = DefaultCafeRepository(cafeNetworkService: CafeNetworkService())
        let cafeUseCase = DefaultCafeUseCase(cafeRepository: cafeRepository)
        let viewModel = AddCafeViewModel(cafeUseCase: cafeUseCase)
        let vc = AddCafeViewController.create(with: viewModel, self)
        vc.modalPresentationStyle = .overCurrentContext
        self.navigationController.present(vc, animated: false, completion: nil)
    }
    
    func showGroupScene(with cafeId: Int, _ isFirst: Bool = false) {
        
        /// 방 생성, 그룹 참여 팝업으로 참여 했을 경우
        if isFirst == true, let vc = navigationController.presentedViewController {
            vc.dismiss(animated: false, completion: nil)
        }
        
        let coordinator = DefaultCafeCoordinator(navigationController: self.navigationController)
        coordinator.parentCoordinator = self
        self.childCoordinators.append(coordinator)
        coordinator.start(with: cafeId,isFirst)
    }
 
    func showJoinCafeBottomSheet() {
        let bottomSheet = JoinCafeBottomSheet.create()
        bottomSheet.modalPresentationStyle = .overCurrentContext
        navigationController.present(bottomSheet, animated: false, completion: nil)
    }
    
    func showCafeQuestionScene(_ questionId: Int) {
        let coordinator = DefaultCafeCoordinator(navigationController: self.navigationController)
        coordinator.parentCoordinator = self
        self.childCoordinators.append(coordinator)
        coordinator.showCafeQuestionScene(questionId)
    }
}
