//
//  MyPageCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/16.
//

import UIKit
import SafariServices
import Toast_Swift

protocol MyPageCoordinator: Coordinator {
    func showEditProfileScene(user: User)
    func showMyDrinkStampScene(user: User)
    func showMyPageAlertView(myPageItem: MyPageItem)
    func showPersonalPolicy()
    func showTermsOfService()
    func showSentQuestionListScene()
    func showBlockedFriendListScene()
    func showCafeQuestionScene(_ cafeQuestionId: Int)
    func pop()
    func showLoginScene(_ leaveType: LeaveType)
}

final class DefaultMyPageCoordinator: NSObject, MyPageCoordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    
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
        vc.hidesBottomBarWhenPushed = true
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
    
    func showLoginScene(_ leaveType: LeaveType) {
        if let appCoordinator = parentCoordinator?.parentCoordinator as? AppCoordinator {
            let coordinator = DefaultAuthCoordinator(navigationController: appCoordinator.navigationController)
            appCoordinator.childCoordinators.append(coordinator)
            coordinator.parentCoordinator = appCoordinator
            coordinator.start()
            coordinator.navigationController.view.makeToast(
                leaveType.message,
                duration: 3.0,
                position: .bottom
            )
            appCoordinator.childCoordinators.removeAll(where: { $0 !== coordinator })
        }
    }
    
    func showPersonalPolicy() {
        let safari = SFSafariViewController(url: URL(string: APP.personalInfoProcessingPolicyURL)!)
        navigationController.present(safari, animated: true, completion: nil)
    }
    
    func showTermsOfService() {
        let safari = SFSafariViewController(url: URL(string: APP.termsOfUseURL)!)
        navigationController.present(safari, animated: true, completion: nil)
    }
    
    func showSentQuestionListScene() {
        let questionRepository = DefaultQuestionRepository(
            scrapNetworkService: ScrapNetworkService(),
            questionNetworkService: QuestionNetworkService(),
            likeNetworkService: LikeNetworkService()
        )
        let questionUseCase = DefaultQuestionUseCase(questionRepository: questionRepository)
        let viewModel = SentQuestionListViewModel(questionUseCase: questionUseCase)
        let vc = SentQuestionListViewController.create(
            with: viewModel,
            self
        )
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showBlockedFriendListScene() {
        let reportRepository = DefaultReportRepository(reportNetworkService: ReportNetworkService())
        let reportUseCase = DefaultReportUseCase(reportRepository: reportRepository)
        let viewModel = BlockedFriendListViewModel(reportUseCase: reportUseCase)
        let vc = BlockFriendListViewController.create(
            with: viewModel,
            self
        )
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showCafeQuestionScene(_ cafeQuestionId: Int) {
        let coordinator = DefaultQuestionCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.showCafeQuestionScene(cafeQuestionId)
    }
    
    func pop() {
        self.navigationController.popViewController(animated: true)
    }
}

extension DefaultMyPageCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // 이동 전 ViewController
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
           return
        }

        // child coordinator 가 일을 끝냈다고 알림.
        if let vc = fromViewController as? CafeQuestionViewController {
            childDidFinish(vc.coordinator)
        }
        
    }
}
