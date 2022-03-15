//
//  QuestionCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/16.
//

import UIKit

protocol QuestionCoordinator: Coordinator {
    func showCafeAnswerScene(_ questionId: Int)
    func showCafeAnswerWritingScene(_ question: Question, _ user: User)
    func showCommentScene(_ commentId: Int)
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
    
    func showCafeAnswerScene(_ questionId: Int) {
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
        let viewModel = CafeAnswerViewModel(
            questionUseCase: questionUseCase,
            userUseCase: userUseCase
        )
        let vc = CafeAnswerViewController.create(
            with: viewModel,
            questionId,
            self
        )
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showCafeAnswerWritingScene(_ question: Question, _ user: User) {
        let commentRepository = DefaultCommentRepository(
            commentNetworkService: CommentNetworkService(),
            replyNetworkService: ReplyNetworkService()
        )
        let commentUseCase = DefaultCommentUseCase(commentRepository: commentRepository)
        let viewModel = CafeAnswerWritingViewModel(commentUseCase: commentUseCase)
        let vc = CafeAnswerWritingViewController.create(
            with: question,
            user,
            viewModel,
            self
        )
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showCommentScene(_ commentId: Int) {
        let coordinator = DefaultCommentCoordinator(navigationController: navigationController)
        coordinator.showCommentScene(commentId)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
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
        if fromViewController is CafeAnswerViewController {
            if let presentedVC = navigationController.viewControllers.first {
                presentedVC.tabBarController?.tabBar.isHidden = false
            }
        }
    }
}
