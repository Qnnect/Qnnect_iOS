//
//  MyPageCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/16.
//

import UIKit

protocol MyPageCoordinator: Coordinator {
    func showEditProfileScene(user: User)
    func pop()
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
    
    func pop() {
        self.navigationController.popViewController(animated: true)
    }
}
