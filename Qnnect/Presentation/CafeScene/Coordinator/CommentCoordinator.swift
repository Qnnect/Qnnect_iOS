//
//  CommentCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/16.
//

import UIKit


protocol CommentCoordinator: Coordinator {
    func showCommentScene(_ commentId: Int, _ question: Question)
    func showCommentMoreMenuBottomSheet(_ question: Question, _ comment: Comment)
    func showReplyMoreMenuBottomSheet(_ commentId: Int,_ reply: Reply)
    func showModifyReplyScene(_ commentId: Int,_ reply: Reply)
    func showWriteCommentScene(_ question: Question, _ user: User?, _ comment: Comment)
    func dismissCommentMoreMenu(_ type: CommentMoreMenuItem)
    func dismissReplyMoreMenu()
    func pop()
}

extension CommentCoordinator {
    func showWriteCommentScene(_ question: Question, _ comment: Comment) {
        showWriteCommentScene(question, nil, comment)
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
    func showCommentScene(_ commentId: Int, _ question: Question) {
        let commentRepository = DefaultCommentRepository(
            commentNetworkService: CommentNetworkService(),
            replyNetworkService: ReplyNetworkService()
        )
        let commentUseCase = DefaultCommentUseCase(commentRepository: commentRepository)
        let viewModel = CommentViewModel(commentUseCase: commentUseCase)
        let vc = CommentViewController.create(
            with: viewModel,
            commentId,
            self,
            question
        )
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showCommentMoreMenuBottomSheet(_ question: Question, _ comment: Comment) {
        let commentRepository = DefaultCommentRepository(
            commentNetworkService: CommentNetworkService(),
            replyNetworkService: ReplyNetworkService()
        )
        let commentUseCase = DefaultCommentUseCase(commentRepository: commentRepository)
        let viewModel = CommentMoreMenuViewModel(commentUseCase: commentUseCase)
        let view = CommentMoreMenuBottomSheet.create(
            with: comment,
            viewModel,
            self,
            question
        )
        view.modalPresentationStyle = .overCurrentContext
        self.navigationController.present(view, animated: false, completion: nil)
    }
    
    func showReplyMoreMenuBottomSheet(_ commentId: Int,_ reply: Reply) {
        let commentRepository = DefaultCommentRepository(
            commentNetworkService: CommentNetworkService(),
            replyNetworkService: ReplyNetworkService()
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
            replyNetworkService: ReplyNetworkService()
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
    
    func showWriteCommentScene(_ question: Question, _ user: User?, _ comment: Comment) {
        dismissCommentMoreMenu(.modify)
        let coordinator = DefaultWriteCommentCoordinator(navigationController: navigationController)
        coordinator.start(question, user, comment)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
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



