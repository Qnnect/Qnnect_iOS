//
//  OurCafeCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/17.
//

import UIKit

protocol OurCafeCoordinator: Coordinator {
    func start(cafeId: Int, cafeUserId: Int)
    func showInsertIngredientScene(_ cafeId: Int)
    func showRecipeScene(cafeId: Int, userDrinkSelectedId: Int)
    func showIngredientStorageScene()
    func showRightStepAlertView(_ ingredient: MyIngredient, _ userDrinkSelectedId: Int)
    func showStoreScene()
    func showDrinkSelectBottomSheet(_ cafeId: Int)
    func dismiss()
}

final class DefaultOurCafeCoordinator: NSObject, OurCafeCoordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func start(cafeId: Int, cafeUserId: Int) {
        let ourCafeRepository = DefaultOurCafeRepository(ourCafeNetworkService: OurCafeNetworkService())
        let ourCafeUseCase = DefaultOurCafeUseCase(ourCafeRepository: ourCafeRepository)
        let viewModel = OurCafeViewModel(ourCafeUseCase: ourCafeUseCase)
        let vc = OurCafeViewController.create(
            with: viewModel,
            self,
            cafeId: cafeId,
            cafeUserId: cafeUserId
        )
        navigationController.pushViewController(vc, animated: true)
        navigationController.tabBarController?.tabBar.isHidden = true
    }
    
    func showInsertIngredientScene(_ cafeId: Int) {
        let ourCafeRepository = DefaultOurCafeRepository(ourCafeNetworkService: OurCafeNetworkService())
        let ourCafeUseCase = DefaultOurCafeUseCase(ourCafeRepository: ourCafeRepository)
        let viewModel = InsertIngredientViewModel(ourCafeUseCase: ourCafeUseCase)
        let vc = InsertIngredientViewController.create(
            with: viewModel,
            self,
            cafeId
        )
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showRecipeScene(cafeId: Int, userDrinkSelectedId: Int) {
        let ourCafeRepository = DefaultOurCafeRepository(ourCafeNetworkService: OurCafeNetworkService())
        let ourCafeUseCase = DefaultOurCafeUseCase(ourCafeRepository: ourCafeRepository)
        let viewModel = RecipeViewModel(ourCafeUseCase: ourCafeUseCase)
        let vc = RecipeViewController.create(
            with: viewModel,
            self,
            cafeId: cafeId,
            userDrinkSelectedId: userDrinkSelectedId
        )
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showStoreScene() {
        let coordinator = DefaultStoreCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func showIngredientStorageScene() {
        let coordinator = DefaultStorageCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func showRightStepAlertView(_ ingredient: MyIngredient, _ userDrinkSelectedId: Int) {
        let ourCafeRepository = DefaultOurCafeRepository(ourCafeNetworkService: OurCafeNetworkService())
        let ourCafeUseCase = DefaultOurCafeUseCase(ourCafeRepository: ourCafeRepository)
        let viewModel = RightStepAlertViewModel(ourCafeUseCase: ourCafeUseCase)
        let vc = RightStepAlertViewController.create(with: viewModel, self, ingredient, userDrinkSelectedId)
        vc.modalPresentationStyle = .overCurrentContext
        navigationController.present(vc, animated: true, completion: nil)
    }
    
    func showDrinkSelectBottomSheet(_ cafeId: Int) {
        let coordinator = DefaultSelectDrinkCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start(cafeId)
    }
    
    func dismiss() {
        navigationController.presentedViewController?.dismiss(animated: true, completion: nil)
    }
}

extension DefaultOurCafeCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // 이동 전 ViewController
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
           return
        }

        // child coordinator 가 일을 끝냈다고 알림.
        if let vc = fromViewController as? StoreViewController {
            childDidFinish(vc.coordinator)
        }
        if let vc = fromViewController as? IngredientStorageViewController {
            childDidFinish(vc.coordinator)
        }
    }
}
