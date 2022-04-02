//
//  QuestionCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/16.
//

import UIKit

protocol QuestionCoordinator: Coordinator {
    func showCafeQuestionScene(_ questionId: Int)
    func showWriteCommentScene(_ question: Question, _ user: User, _ comment: Comment?)
    func showCommentScene(_ commentId: Int, _ question: Question)
    func showModifyQuestionScene(_  question: Question)
    func showReportMenuBottomSheet(_ reportUser: User)
    func pop()
    func dismiss()
}

extension QuestionCoordinator {
    func showWriteCommentScene(_ question: Question, _ user: User) {
        showWriteCommentScene(question, user, nil)
    }
}

final class DefaultQuestionCoordinator: NSObject, QuestionCoordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func showCafeQuestionScene(_ questionId: Int) {
        let questionRepository = DefaultQuestionRepository(
            scrapNetworkService: ScrapNetworkService(),
            questionNetworkService: QuestionNetworkService(),
            likeNetworkService: LikeNetworkService()
        )
        let questionUseCase = DefaultQuestionUseCase(questionRepository: questionRepository)
        let userRepository = DefaultUserRepositry(
            userNetworkService: UserNetworkService(),
            localStorage: DefaultUserDefaultManager()
        )
        let userUseCase = DefaultUserUseCase(userRepository: userRepository)
        let viewModel = CafeQuestionViewModel(
            questionUseCase: questionUseCase,
            userUseCase: userUseCase
        )
        let vc = CafeQuestionViewController.create(
            with: viewModel,
            questionId,
            self
        )
        vc.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showWriteCommentScene(_ question: Question, _ user: User, _ comment: Comment?) {
        let coordinator = DefaultWriteCommentCoordinator(navigationController: navigationController)
        navigationController.delegate = self
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start(question, user, comment)
    }
    
    func showCommentScene(_ commentId: Int, _ question: Question) {
        let coordinator = DefaultCommentCoordinator(navigationController: navigationController)
        navigationController.delegate = self
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.showCommentScene(commentId, question)
    }
    
    func showModifyQuestionScene(_ question: Question) {
//        let questionRepository = DefaultQuestionRepository(
//            scrapNetworkService: ScrapNetworkService(),
//            questionNetworkService: QuestionNetworkService(),
//            likeNetworkService: LikeNetworkService()
//        )
//        let questionUseCase = DefaultQuestionUseCase(questionRepository: questionRepository)
//        let viewModel = ModifyQuestionViewModel(questionUseCase: questionUseCase)
//        let vc = ModifyQuestionViewController.create(
//            with: viewModel,
//            self,
//            question
//        )
//        navigationController.pushViewController(vc, animated: true)
        let coordinator = DefaultModifyQuestionCoordinator(navigationController: navigationController)
        navigationController.delegate = self
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start(question)
    }
    
    func showReportMenuBottomSheet(_ reportUser: User) {
        let coordinator = DefaultReportCoordinator(navigationController: navigationController)
        navigationController.delegate = self
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start(reportUser)
    }
    func pop() {
        navigationController.popViewController(animated: true)
    }
    
    func dismiss() {
        navigationController.presentedViewController?.dismiss(animated: false, completion: nil)
    }
}

extension DefaultQuestionCoordinator: UINavigationControllerDelegate {
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
        if let vc = fromViewController as? WriteCommentViewController {
            childDidFinish(vc.coordinator)
            navigationController.delegate = parentCoordinator
        }
        
        if let vc = fromViewController as? CommentViewController {
            childDidFinish(vc.coordinator)
            navigationController.delegate = parentCoordinator
        }
        
        if let vc = fromViewController as? ReportBottomSheet {
            childDidFinish(vc.coordinator)
            navigationController.delegate = parentCoordinator
        }
        
        if let vc = fromViewController as? ModifyQuestionViewController {
            childDidFinish(vc.coordinator)
            navigationController.delegate = parentCoordinator
        }
    }
}
