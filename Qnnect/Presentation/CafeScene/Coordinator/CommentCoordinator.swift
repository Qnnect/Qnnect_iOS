//
//  CommentCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/16.
//

import UIKit

protocol CommentCoordinator: Coordinator {
    func showCommentScene(_ commentId: Int)
    func showCommentMoreMenuBottomSheet(_ commentId: Int)
    func showReplyMoreMenuBottomSheet(replyId: Int, commentId: Int)
    func showModifyReplyScene(replyId: Int, commentId: Int)
    func dismissCommentMoreMenu()
    func dismissReplyMoreMenu()
}

final class DefaultCommentCoordinator: NSObject, CommentCoordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
    func start() { }
    func showCommentScene(_ commentId: Int) {
        let commentRepository = DefaultCommentRepository(
            commentNetworkService: CommentNetworkService(),
            replyNetworkService: ReplyNetworkService()
        )
        let commentUseCase = DefaultCommentUseCase(commentRepository: commentRepository)
        let viewModel = CommentViewModel(commentUseCase: commentUseCase)
        let vc = CommentViewController.create(
            with: viewModel,
            commentId,
            self
        )
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showCommentMoreMenuBottomSheet(_ commentId: Int) {
        let commentRepository = DefaultCommentRepository(
            commentNetworkService: CommentNetworkService(),
            replyNetworkService: ReplyNetworkService()
        )
        let commentUseCase = DefaultCommentUseCase(commentRepository: commentRepository)
        let viewModel = CommentMoreMenuViewModel(commentUseCase: commentUseCase)
        let view = CommentMoreMenuBottomSheet.create(with: commentId, viewModel, self)
        view.modalPresentationStyle = .overCurrentContext
        self.navigationController.present(view, animated: false, completion: nil)
    }
    
    func showReplyMoreMenuBottomSheet(replyId: Int, commentId: Int) {
        let commentRepository = DefaultCommentRepository(
            commentNetworkService: CommentNetworkService(),
            replyNetworkService: ReplyNetworkService()
        )
        let commentUseCase = DefaultCommentUseCase(commentRepository: commentRepository)
        let viewModel = ReplyMoreMenuViewModel(commentUseCase: commentUseCase)
        let view = ReplyMoreMenuBottomSheet.create(
            with: viewModel,
            self,
            replyId: replyId,
            commentId: commentId
        )
        view.modalPresentationStyle = .overCurrentContext
        self.navigationController.present(view, animated: false, completion: nil)
    }
    
    func showModifyReplyScene(replyId: Int, commentId: Int) {
        let commentRepository = DefaultCommentRepository(
            commentNetworkService: CommentNetworkService(),
            replyNetworkService: ReplyNetworkService()
        )
        let commentUseCase = DefaultCommentUseCase(commentRepository: commentRepository)
        let viewModel = ModifyReplyViewModel(commentUseCase: commentUseCase)
        let view = ModifyReplyViewController.create(
            with: viewModel,
            self,
            commentId: commentId,
            replyId: replyId
        )
        dismissReplyMoreMenu()
        self.navigationController.pushViewController(view, animated: true)
    }
    
    func dismissCommentMoreMenu() {
        if let vc = self.navigationController.presentedViewController as? CommentMoreMenuBottomSheet {
            vc.hideBottomSheetAndGoBack {
                [weak self] in
                self?.navigationController.popViewController(animated: true)
            }
        }
    }
    
    func dismissReplyMoreMenu() {
        if let vc = self.navigationController.presentedViewController as? ReplyMoreMenuBottomSheet {
            vc.hideBottomSheetAndGoBack(nil)
        }
    }
}



