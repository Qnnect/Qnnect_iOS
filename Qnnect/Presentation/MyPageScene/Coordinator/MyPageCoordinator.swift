//
//  MyPageCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/16.
//

import UIKit

protocol MyPageCoordinator: Coordinator {
    func showEditProfileScene(user: User)
    func showMyDrinkStampScene(user: User)
    func showMyPageAlertView(myPageItem: MyPageItem)
    func pop()
    func showLoginScene()
}

final class DefaultMyPageCoordinator: MyPageCoordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let userRepository = DefaultUserRepositry(
            userNetworkService: UserNetworkService(),
            localStorage: DefaultUserDefaultManager()
        )
        let userUseCase = DefaultUserUseCase(userRepository: userRepository)
        let viewModel = MyPageViewModel(userUseCase: userUseCase)
        let vc = MyPageViewController.create(with: viewModel, self)
        self.navigationController.pushViewController(vc, animated: true)
    }
        
    func showEditProfileScene(user: User) {
        let authUseCase = DefaultAuthUseCase(authRepository: DefaultAuthRepository(localStorage: DefaultUserDefaultManager(), authNetworkService: AuthNetworkService()))
        let userRepository = DefaultUserRepositry(
            userNetworkService: UserNetworkService(),
            localStorage: DefaultUserDefaultManager()
        )
        let userUseCase = DefaultUserUseCase(userRepository: userRepository)
        let viewModel = EditProfileViewModel(
            authUseCase: authUseCase,
            userUseCase: userUseCase
        )
        let vc = EditProfileViewController.create(with: viewModel,user, self)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showMyDrinkStampScene(user: User) {
        let vc = MyDrinkStampViewController.create(with: self, user)
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showMyPageAlertView(myPageItem: MyPageItem) {
        let authUseCase = DefaultAuthUseCase(authRepository: DefaultAuthRepository(localStorage: DefaultUserDefaultManager(), authNetworkService: AuthNetworkService()))
        let viewModel = MyPageAlertViewModel(authUseCase: authUseCase)
        let view = MyPageAlertViewController.create(with: viewModel, self, myPageItem)
        view.modalPresentationStyle = .overCurrentContext
        navigationController.present(view, animated: true, completion: nil)
    }
    
    func showLoginScene() {
        if let appCoordinator = parentCoordinator?.parentCoordinator as? AppCoordinator {
            let coordinator = DefaultAuthCoordinator(navigationController: appCoordinator.navigationController)
            print("appCoordinator navigationController viewControllers \(appCoordinator.navigationController.viewControllers)")
            appCoordinator.childCoordinators.append(coordinator)
            coordinator.parentCoordinator = appCoordinator
            coordinator.start()
            appCoordinator.childCoordinators.removeAll(where: { $0 !== coordinator })
        }
    }
    
    func pop() {
        self.navigationController.popViewController(animated: true)
    }
}
