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
    func start(with cafeId: Int, _ isFirst: Bool)
    func showDrinkSelectGuideAlertView(_ type: UserBehaviorType)
    func showSettingBottomSheet(_ cafe: Cafe)
    func showInvitationScene()
    func showCafeAnswerScene(_ question: Question, _ user: User)
    func showCafeAnswerWritingScene(_ question: Question, _ user: User)
    func showCafeModifyingScene(_ cafe: Cafe)
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
    
    func showSelectDrinkBottomSheet() {
        let vc = DrinkSelectViewController.create()
        vc.modalPresentationStyle = .overCurrentContext
        
        if let vc = self.navigationController.presentedViewController as? DrinkSelectGuideAlertView {
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
    
    func showSettingBottomSheet(_ cafe: Cafe) {
        let viewModel = SettingBottomSheetViewModel(coordinator: self)
        let bottomSheet = SettingBottomSheet.create(with: viewModel,cafe)
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
    
    func showCafeAnswerScene(_ question: Question, _ user: User) {
        let viewModel = CafeAnswerViewModel(coordinator: self)
        let vc = CafeAnswerViewController.create(
            with: viewModel,
            question,
            user
        )
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showCafeAnswerWritingScene(_ question: Question, _ user: User) {
        let viewModel = CafeAnswerWritingViewModel(coordinator: self)
        let vc = CafeAnswerWritingViewController.create(
            with: question,
            user,
            viewModel
        )
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showCafeModifyingScene(_ cafe: Cafe) {
        let vc = CafeModifyingViewController.create()
        if let bottomSheet = self.navigationController.presentedViewController as? SettingBottomSheet {
            bottomSheet.hideBottomSheetAndGoBack {
                [weak self] in
                vc.modalPresentationStyle = .overCurrentContext
                self?.navigationController.present(vc, animated: false, completion: nil)
            }
        }
       
    }
    
    func dismissAlert() {
        self.navigationController.presentedViewController?.dismiss(animated: true, completion: nil)
    }
}
