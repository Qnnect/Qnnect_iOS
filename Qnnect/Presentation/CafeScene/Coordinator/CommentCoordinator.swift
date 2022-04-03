//
//  CommentCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/16.
//

import UIKit


protocol CommentCoordinator: Coordinator {
    func start(_ commentId: Int, _ cafeQuestionId: Int)
    func showCommentMoreMenuBottomSheet(_ cafeQuestionId: Int, _ comment: Comment)
    func showReplyMoreMenuBottomSheet(_ commentId: Int,_ reply: Reply)
    func showModifyReplyScene(_ commentId: Int,_ reply: Reply)
    func showWriteCommentScene(_ cafeQuestionId: Int, _ user: User?, _ comment: Comment)
    func showReportBottomSheet(_ reportUser: User)
    func dismissCommentMoreMenu(_ type: CommentMoreMenuItem)
    func dismissReplyMoreMenu()
    func pop()
}

extension CommentCoordinator {
    func showWriteCommentScene(_ cafeQuestionId: Int, _ comment: Comment) {
        showWriteCommentScene(cafeQuestionId, nil, comment)
    }
}

final class DefaultCommentCoordinator: NSObject, CommentCoordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
    func start() { }
    
    func start(_ commentId: Int, _ cafeQuestionId: Int) {
        let commentRepository = DefaultCommentRepository(
            commentNetworkService: CommentNetworkService(),
            replyNetworkService: ReplyNetworkService(),
            questionNetworkService: QuestionNetworkService()
        )
        let commentUseCase = DefaultCommentUseCase(commentRepository: commentRepository)
        let viewModel = CommentViewModel(commentUseCase: commentUseCase)
        let vc = CommentViewController.create(
            with: viewModel,
            commentId,
            self,
            cafeQuestionId
        )
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showCommentMoreMenuBottomSheet(_ cafeQuestionId: Int, _ comment: Comment) {
        let commentRepository = DefaultCommentRepository(
            commentNetworkService: CommentNetworkService(),
            replyNetworkService: ReplyNetworkService(),
            questionNetworkService: QuestionNetworkService()
        )
        let commentUseCase = DefaultCommentUseCase(commentRepository: commentRepository)
        let viewModel = CommentMoreMenuViewModel(commentUseCase: commentUseCase)
        let view = CommentMoreMenuBottomSheet.create(
            with: comment,
            viewModel,
            self,
            cafeQuestionId
        )
        view.modalPresentationStyle = .overCurrentContext
        self.navigationController.present(view, animated: false, completion: nil)
    }
    
    func showReplyMoreMenuBottomSheet(_ commentId: Int,_ reply: Reply) {
        let commentRepository = DefaultCommentRepository(
            commentNetworkService: CommentNetworkService(),
            replyNetworkService: ReplyNetworkService(),
            questionNetworkService: QuestionNetworkService()
        )
        let commentUseCase = DefaultCommentUseCase(commentRepository: commentRepository)
        let viewModel = ReplyMoreMenuViewModel(commentUseCase: commentUseCase)
        let view = ReplyMoreMenuBottomSheet.create(
            with: viewModel,
            self,
            reply,
            commentId
        )
        view.modalPresentationStyle = .overCurrentContext
        self.navigationController.present(view, animated: false, completion: nil)
    }
    
    func showModifyReplyScene(_ commentId: Int,_ reply: Reply) {
        let commentRepository = DefaultCommentRepository(
            commentNetworkService: CommentNetworkService(),
            replyNetworkService: ReplyNetworkService(),
            questionNetworkService: QuestionNetworkService()
        )
        let commentUseCase = DefaultCommentUseCase(commentRepository: commentRepository)
        let viewModel = ModifyReplyViewModel(commentUseCase: commentUseCase)
        let view = ModifyReplyViewController.create(
            with: viewModel,
            self,
            reply,
            commentId
        )
        dismissReplyMoreMenu()
        self.navigationController.pushViewController(view, animated: true)
    }
    
    func showWriteCommentScene(_ cafeQuestionId: Int, _ user: User?, _ comment: Comment) {
        dismissCommentMoreMenu(.modify)
        let coordinator = DefaultWriteCommentCoordinator(navigationController: navigationController)
        navigationController.delegate = self
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start(cafeQuestionId, user, comment)
    }
    
    func showReportBottomSheet(_ reportUser: User) {
        let coordinator = DefaultReportCoordinator(navigationController: navigationController)
        navigationController.delegate = self
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start(reportUser)
    }
    
    func dismissCommentMoreMenu(_ type: CommentMoreMenuItem) {
        if let vc = self.navigationController.presentedViewController as? CommentMoreMenuBottomSheet {
            vc.hideBottomSheetAndGoBack {
                [weak self] in
                if type == .delete {
                    self?.navigationController.popViewController(animated: true)
                }
            }
        }
    }
    
    func dismissReplyMoreMenu() {
        if let vc = self.navigationController.presentedViewController as? ReplyMoreMenuBottomSheet {
            vc.hideBottomSheetAndGoBack(nil)
        }
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
}

extension DefaultCommentCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool)
    {
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
        
        if let vc = fromViewController as? ReportBottomSheet {
            childDidFinish(vc.coordinator)
            navigationController.delegate = parentCoordinator
        }
    }
}
    
