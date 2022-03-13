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
    func start(with cafeId: Int, _ isFirst: Bool)
    func showDrinkSelectGuideAlertView(_ type: UserBehaviorType, _ cafeId: Int)
    func showSettingBottomSheet(_ cafeId: Int)
    func showInvitationScene()
    func showCafeAnswerScene(_ question: Question, _ user: User, _ cafeId: Int)
    func showCafeAnswerWritingScene(_ question: Question, _ user: User, _ cafeId: Int)
    func showCafeModifyingScene(_ cafeId: Int)
    func showWriteQuestionScene(_ cafeId: Int)
    func dismissAlert()
    func dismiss()
    func leaveCafe()
}

final class DefaultGroupCoordinator: CafeCoordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func start(with cafeId: Int, _ isFirst: Bool = false) {
        let cafeRepository = DefaultCafeRepository(cafeNetworkService: CafeNetworkService())
        let cafeUseCase = DefaultCafeUseCase(cafeRepository: cafeRepository)
        let viewModel = CafeRoomViewModel(
            coordinator: self,
            cafeUseCase: cafeUseCase
        )
        let vc = CafeRoomViewController.create(with: viewModel,cafeId,isFirst)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showSelectDrinkBottomSheet(_ cafeId: Int) {
        let drinkRepository = DefaultDrinkRepository(drinkNetworkService: DrinkNetworkService())
        let drinkUseCase = DefaultDrinkUseCase(drinkRepository: drinkRepository)
        let viewModel = DrinkSelctViewModel(coordinator: self, drinkUseCase: drinkUseCase)
        let vc = DrinkSelectViewController.create(with: viewModel, cafeId)
        vc.modalPresentationStyle = .overCurrentContext
        if let vc = self.navigationController.presentedViewController as? DrinkSelectGuideAlertView {
            vc.dismiss(animated: false, completion: nil)
        }
        self.navigationController.present(vc, animated: false, completion: nil)
    }
    
    func showDrinkSelectGuideAlertView(_ type: UserBehaviorType, _ cafeId: Int) {
        let viewModel = DrinkSelectGuideAlertViewModel(coordinator: self)
        let alert = DrinkSelectGuideAlertView.create(with: viewModel, type, cafeId)
        alert.modalPresentationStyle = .overCurrentContext
        self.navigationController.present(alert, animated: true, completion: nil)
    }
    
    func showSettingBottomSheet(_ cafeId: Int) {
        let cafeRepository = DefaultCafeRepository(cafeNetworkService: CafeNetworkService())
        let cafeUseCase = DefaultCafeUseCase(cafeRepository: cafeRepository)
        let viewModel = SettingBottomSheetViewModel(coordinator: self,cafeUseCase: cafeUseCase)
        let bottomSheet = SettingBottomSheet.create(with: viewModel,cafeId)
        bottomSheet.modalPresentationStyle = .overCurrentContext
        self.navigationController.present(bottomSheet, animated: false,completion: nil)
    }
    
    func showInvitationScene() {
        let vc = CafeInvitationViewController.create()
        if let bottomSheet = self.navigationController.presentedViewController as? SettingBottomSheet {
            bottomSheet.hideBottomSheetAndGoBack(nil)
        }
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showCafeAnswerScene(_ question: Question, _ user: User, _ cafeId: Int) {
        let questionRepository = DefaultQuestionRepository(scrapNetworkService: ScrapNetworkService())
        let questionUseCase = DefaultQuestionUseCase(questionRepository: questionRepository)
        let viewModel = CafeAnswerViewModel(coordinator: self,questionUseCase: questionUseCase)
        let vc = CafeAnswerViewController.create(
            with: viewModel,
            question,
            cafeId,
            user
        )
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showCafeAnswerWritingScene(_ question: Question, _ user: User, _ cafeId: Int) {
        let commentRepository = DefaultCommentRepository(commentNetworkService: CommentNetworkService())
        let commentUseCase = DefaultCommentUseCase(commentRepository: commentRepository)
        let viewModel = CafeAnswerWritingViewModel(coordinator: self, commentUseCase: commentUseCase)
        let vc = CafeAnswerWritingViewController.create(
            with: question,
            user,
            cafeId,
            viewModel
        )
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showCafeModifyingScene(_ cafeId: Int) {
        let cafeRepository = DefaultCafeRepository(cafeNetworkService: CafeNetworkService())
        let cafeUseCase = DefaultCafeUseCase(cafeRepository: cafeRepository)
        let viewModel = CafeModifyingViewModel(
            coordinator: self,
            cafeUseCase: cafeUseCase
        )
        let vc = CafeModifyingViewController.create(with: viewModel, cafeId)
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
        let viewModel = WriteQuestionViewModel(
            coordinator: self,
            cafeUseCase: cafeUseCase
        )
        let vc = WriteQuestionViewController.create(with: viewModel, cafeId)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func dismissAlert() {
        self.navigationController.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func dismiss() {
        if let vc = self.navigationController.presentedViewController as? BottomSheetViewController {
            vc.hideBottomSheetAndGoBack(nil)
        } else {
            self.navigationController.presentedViewController?.dismiss(animated: true, completion: nil)
        }
        if let vc = self.navigationController.viewControllers.first(where: { $0 is CafeRoomViewController}) as? CafeRoomViewController {
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
