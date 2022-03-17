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
    func pop()
}

extension QuestionCoordinator {
    func showWriteCommentScene(_ question: Question, _ user: User) {
        showWriteCommentScene(question, user, nil)
    }
}

final class DefaultQuestionCoordinator: NSObject, QuestionCoordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        navigationController.delegate = self
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
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showWriteCommentScene(_ question: Question, _ user: User, _ comment: Comment?) {
        let coordinator = DefaultWriteCommentCoordinator(navigationController: navigationController)
        coordinator.start(question, user, comment)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
    }
    
    func showCommentScene(_ commentId: Int, _ question: Question) {
        let coordinator = DefaultCommentCoordinator(navigationController: navigationController)
        coordinator.showCommentScene(commentId, question)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
    }
    
    func showModifyQuestionScene(_ question: Question) {
        let questionRepository = DefaultQuestionRepository(
            scrapNetworkService: ScrapNetworkService(),
            questionNetworkService: QuestionNetworkService(),
            likeNetworkService: LikeNetworkService()
        )
        let questionUseCase = DefaultQuestionUseCase(questionRepository: questionRepository)
        let viewModel = ModifyQuestionViewModel(questionUseCase: questionUseCase)
        let vc = ModifyQuestionViewController.create(
            with: viewModel,
            self,
            question
        )
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
}

extension DefaultQuestionCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // 이동 전 ViewController
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
           return
        }

        // child coordinator 가 일을 끝냈다고 알림.
        if let vc = fromViewController as? CommentViewController {
            childDidFinish(vc.coordinator)
        }
        
        if let vc = fromViewController as? WriteCommentViewController {
            childDidFinish(vc.coordinator)
        }
    }
}
