//
//  GroupCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/28.
//

import Foundation
import UIKit

protocol CafeCoordinator: Coordinator {
    func showSelectDrinkBottomSheet(_ cafeId: Int)
    func start(with cafeId: Int)
    func showDrinkSelectGuideAlertView(_ type: UserBehaviorType, _ cafeId: Int)
    func showSettingBottomSheet(_ cafe: Cafe)
    func showInvitationScene(_ cafe: Cafe)
    func showCafeQuestionScene(_ questionId: Int)
    func showCafeModifyingScene(_ cafeId: Int)
    func showWriteQuestionScene(_ cafeId: Int)
    func showQuestionCompletionAlertView()
    func showCafeQuestionListScene(_ cafeId: Int)
    func showSearchCafeQuestionScene(_ cafeId: Int)
    func showOurCafeScene(cafeId:Int, cafeUserId: Int)
    func dismissQuestionCompletionAlertView(_ type: QuestionCompletionBehaviorType)
    func dismissAlert()
    func dismissDrinkSelectBottomSheet()
    func leaveCafe()
}

final class DefaultCafeCoordinator: NSObject, CafeCoordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        //navigationController.delegate = self
    }
    
    func start() { }
    
    func start(with cafeId: Int) {
        let cafeRepository = DefaultCafeRepository(cafeNetworkService: CafeNetworkService())
        let cafeUseCase = DefaultCafeUseCase(cafeRepository: cafeRepository)
        let viewModel = CafeRoomViewModel(cafeUseCase: cafeUseCase)
        let vc = CafeRoomViewController.create(with: viewModel, cafeId, self)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showSelectDrinkBottomSheet(_ cafeId: Int) {
        navigationController.delegate = self
        if let bottomSheet = self.navigationController.presentedViewController as? SettingBottomSheet {
            bottomSheet.hideBottomSheetAndGoBack {
                [weak self] in
                guard let self = self else { return }
                let coordinator = DefaultSelectDrinkCoordinator(navigationController: self.navigationController)
                coordinator.parentCoordinator = self
                self.childCoordinators.append(coordinator)
                coordinator.start(cafeId)
            }
        } else {
            let coordinator = DefaultSelectDrinkCoordinator(navigationController: navigationController)
            coordinator.parentCoordinator = self
            childCoordinators.append(coordinator)
            coordinator.start(cafeId)
            
        }
    }
    
    func showDrinkSelectGuideAlertView(_ type: UserBehaviorType, _ cafeId: Int) {
        let viewModel = DrinkSelectGuideAlertViewModel()
        let alert = DrinkSelectGuideAlertView.create(with: viewModel, type, cafeId, self)
        alert.modalPresentationStyle = .overCurrentContext
        self.navigationController.present(alert, animated: true, completion: nil)
    }
    
    func showSettingBottomSheet(_ cafe: Cafe) {
        let cafeRepository = DefaultCafeRepository(cafeNetworkService: CafeNetworkService())
        let cafeUseCase = DefaultCafeUseCase(cafeRepository: cafeRepository)
        let viewModel = SettingBottomSheetViewModel(cafeUseCase: cafeUseCase)
        let bottomSheet = SettingBottomSheet.create(with: viewModel,cafe, self)
        bottomSheet.modalPresentationStyle = .overCurrentContext
        self.navigationController.present(bottomSheet, animated: false,completion: nil)
    }
    
    func showInvitationScene(_ cafe: Cafe) {
        let viewModel = InviteCafeViewModel()
        let vc = InviteCafeViewController.create(
            with: viewModel,
            cafe,
            self
        )
        if let bottomSheet = self.navigationController.presentedViewController as? SettingBottomSheet {
            bottomSheet.hideBottomSheetAndGoBack(nil)
        }
        vc.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showCafeQuestionScene(_ questionId: Int) {
        let coordinator = DefaultQuestionCoordinator(navigationController: navigationController)
        navigationController.delegate = self
        coordinator.showCafeQuestionScene(questionId)
        coordinator.parentCoordinator = parentCoordinator
        self.childCoordinators.append(coordinator)
    }
    
    func showCafeModifyingScene(_ cafeId: Int) {
        let cafeRepository = DefaultCafeRepository(cafeNetworkService: CafeNetworkService())
        let cafeUseCase = DefaultCafeUseCase(cafeRepository: cafeRepository)
        let viewModel = CafeModifyingViewModel(cafeUseCase: cafeUseCase)
        let vc = CafeModifyingViewController.create(with: viewModel, cafeId, self)
        if let bottomSheet = self.navigationController.presentedViewController as? SettingBottomSheet {
            bottomSheet.hideBottomSheetAndGoBack {
                [weak self] in
                vc.modalPresentationStyle = .overCurrentContext
                self?.navigationController.present(vc, animated: false, completion: nil)
            }
        }
        
    }
    
    func showWriteQuestionScene(_ cafeId: Int) {
        let cafeRepository = DefaultCafeRepository(cafeNetworkService: CafeNetworkService())
        let cafeUseCase = DefaultCafeUseCase(cafeRepository: cafeRepository)
        let viewModel = WriteQuestionViewModel(cafeUseCase: cafeUseCase)
        let vc = WriteQuestionViewController.create(with: viewModel, cafeId, self)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showQuestionCompletionAlertView() {
        let viewModel = QuestionCompletionAlertViewModel()
        let view = QuestionCompletionAlertView.create(with: viewModel, self)
        view.modalPresentationStyle = .overCurrentContext
        navigationController.present(view, animated: true, completion: nil)
    }
    
    func showCafeQuestionListScene(_ cafeId: Int) {
        let questionRepository = DefaultQuestionRepository(
            scrapNetworkService: ScrapNetworkService(),
            questionNetworkService: QuestionNetworkService(),
            likeNetworkService: LikeNetworkService()
        )
        let questionUseCase = DefaultQuestionUseCase(questionRepository: questionRepository)
        let viewModel = CafeQuestionListViewModel(questionUseCase: questionUseCase)
        let vc = CafeQuestionListViewController.create(
            with: viewModel,
            self,
            cafeId
        )
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showSearchCafeQuestionScene(_ cafeId: Int) {
        let questionRepository = DefaultQuestionRepository(
            scrapNetworkService: ScrapNetworkService(),
            questionNetworkService: QuestionNetworkService(),
            likeNetworkService: LikeNetworkService()
        )
        let questionUseCase = DefaultQuestionUseCase(questionRepository: questionRepository)
        let viewModel = SearchCafeQuestionViewModel(questionUseCase: questionUseCase)
        let vc = SearchCafeQuestionViewController.create(
            with: viewModel,
            self,
            cafeId
        )
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showOurCafeScene(cafeId: Int, cafeUserId: Int) {
        let coordinator = DefaultOurCafeCoordinator(navigationController: navigationController)
        navigationController.delegate = self
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start(cafeId: cafeId, cafeUserId: cafeUserId)
        
    }
    
    func dismissQuestionCompletionAlertView(_ type: QuestionCompletionBehaviorType) {
        if let view = self.navigationController.presentedViewController as? QuestionCompletionAlertView {
            view.dismiss(animated: true, completion: {
                [weak self] in
                switch type {
                case .goCafe:
                    self?.navigationController.popViewController(animated: true)
                case .goMyQuestion:
                    self?.navigationController.popToRootViewController(animated: false)
                    self?.navigationController.tabBarController?.selectedIndex = 3
                    if let naviVC = self?.navigationController.tabBarController?.selectedViewController as? UINavigationController,
                       let vc = naviVC.viewControllers.last as? MyPageViewController {
                        vc.coordinator?.showSentQuestionListScene()
                    }
                }
            })
        }
    }
    
    func dismissAlert() {
        self.navigationController.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func dismissDrinkSelectBottomSheet() {
        if let vc = self.navigationController.presentedViewController as? BottomSheetViewController {
            vc.hideBottomSheetAndGoBack(nil)
        } else {
            self.navigationController.presentedViewController?.dismiss(animated: true, completion: nil)
        }
        if let vc = self.navigationController.viewControllers.last as? CafeRoomViewController {
            vc.comebackCafeRoom()
        }
    }
    
    func leaveCafe() {
        if let vc = self.navigationController.presentedViewController as? BottomSheetViewController {
            vc.hideBottomSheetAndGoBack {
                [weak self] in
                self?.navigationController.popToRootViewController(animated: true)
            }
        }
    }
    
}

extension DefaultCafeCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // 이동 전 ViewController
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        guard let parentCoordinator = parentCoordinator as? UINavigationControllerDelegate else {
            return
        }
        
        // child coordinator 가 일을 끝냈다고 알림.
        if let vc = fromViewController as? CafeQuestionViewController {
            childDidFinish(vc.coordinator)
            navigationController.delegate = parentCoordinator
        }
        
        if let vc = fromViewController as? OurCafeViewController {
            childDidFinish(vc.coordinator)
            navigationController.delegate = parentCoordinator
        }
        
        if let vc = fromViewController as? DrinkSelectViewController {
            childDidFinish(vc.coordinator)
            navigationController.delegate = parentCoordinator
        }
    }
}
