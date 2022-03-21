//
//  HomeCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/14.
//

import UIKit

protocol HomeCoordinator: Coordinator {
    func showAddGroupBottomSheet()
    func showGroupScene(with cafeId: Int)
    func showJoinCafeBottomSheet()
    func showCafeQuestionScene(_ questionId: Int)
    func startInviteFlow(_ inviteCafeCode: String?)
    func showNotificationListScene()
}

final class DefaultHomeCoordinator: NSObject, HomeCoordinator {
    var childCoordinators: [Coordinator] = [] {
        didSet {
            print("HomeCoordinator Child: \(childCoordinators)")
        }
    }
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let cafeRepository = DefaultCafeRepository(cafeNetworkService: CafeNetworkService())
        let cafeUseCase = DefaultCafeUseCase(cafeRepository: cafeRepository)
        let homeRepository = DefaultHomeRepository(homeNetworkService: HomeNetworkService())
        let homeUseCase = DefaultHomeUseCase(homeRepository: homeRepository)
        let viewModel = HomeViewModel(
            homeUseCase: homeUseCase,
            cafeUseCase: cafeUseCase
        )
        let vc = HomeViewController.create(with: viewModel, self)
        self.navigationController.pushViewController(vc, animated: true)
        self.navigationController.viewControllers.removeAll { $0 != vc }
        navigationController.delegate = self
    }
    
    func startInviteFlow(_ inviteCafeCode: String?) {
        let cafeRepository = DefaultCafeRepository(cafeNetworkService: CafeNetworkService())
        let cafeUseCase = DefaultCafeUseCase(cafeRepository: cafeRepository)
        let homeRepository = DefaultHomeRepository(homeNetworkService: HomeNetworkService())
        let homeUseCase = DefaultHomeUseCase(homeRepository: homeRepository)
        let viewModel = HomeViewModel(
            homeUseCase: homeUseCase,
            cafeUseCase: cafeUseCase
        )
        let vc = HomeViewController.create(with: viewModel, self, inviteCafeCode)
        self.navigationController.pushViewController(vc, animated: true)
        self.navigationController.viewControllers.removeAll { $0 != vc }
        navigationController.delegate = self
    }
    
    func showAddGroupBottomSheet() {
        let cafeRepository = DefaultCafeRepository(cafeNetworkService: CafeNetworkService())
        let cafeUseCase = DefaultCafeUseCase(cafeRepository: cafeRepository)
        let viewModel = AddCafeViewModel(cafeUseCase: cafeUseCase)
        let vc = AddCafeViewController.create(with: viewModel, self)
        vc.modalPresentationStyle = .overCurrentContext
        self.navigationController.present(vc, animated: false, completion: nil)
    }
    
    func showGroupScene(with cafeId: Int) {
        
        /// 방 생성, 그룹 참여 팝업으로 참여 했을 경우
        if let vc = navigationController.presentedViewController {
            vc.dismiss(animated: false, completion: nil)
        }
        let coordinator = DefaultCafeCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        self.childCoordinators.append(coordinator)
        coordinator.start(with: cafeId)
    }
    
    func showJoinCafeBottomSheet() {
        let cafeRepository = DefaultCafeRepository(cafeNetworkService: CafeNetworkService())
        let cafeUseCase = DefaultCafeUseCase(cafeRepository: cafeRepository)
        let viewModel = JoinCafeBottomSheetViewModel(cafeUseCase: cafeUseCase)
        let bottomSheet = JoinCafeBottomSheet.create(
            with: viewModel,
            self
        )
        bottomSheet.modalPresentationStyle = .overCurrentContext
        navigationController.present(bottomSheet, animated: false, completion: nil)
    }
    
    func showCafeQuestionScene(_ questionId: Int) {
        let coordinator = DefaultQuestionCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        self.childCoordinators.append(coordinator)
        coordinator.showCafeQuestionScene(questionId)
    }
    
    func showNotificationListScene() {
        let viewModel = NotificationListViewModel()
        let vc = NotificationListViewController.create(with: viewModel, self)
        navigationController.pushViewController(vc, animated: true)
    }
}

extension DefaultHomeCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // 이동 전 ViewController
        print("HomeCoordinator didShow Call!!")
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        // child coordinator 가 일을 끝냈다고 알림.
        if let vc = fromViewController as? CafeQuestionViewController {
            childDidFinish(vc.coordinator)
//            if let presentedVC = navigationController.viewControllers.last {
//                presentedVC.tabBarController?.tabBar.isHidden = false
//            }
        }
        
        if let vc = fromViewController as? CafeRoomViewController {
            childDidFinish(vc.coordinator)
        }
        
    }
    
}
