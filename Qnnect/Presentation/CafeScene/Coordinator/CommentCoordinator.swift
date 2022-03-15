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
    func showReplyMoreMenuBottomSheet(_ replyId: Int)
    func dismissMoreMenu()
}

final class DefaultCommentCoordinator: NSObject, CommentCoordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        navigationController.delegate = self
    }
    
    func start() { }
    func showCommentScene(_ commentId: Int) {
        let commentRepository = DefaultCommentRepository(
            commentNetworkService: CommentNetworkService(),
            replyNetworkService: ReplyNetworkService()
        )
        let commentUseCase = DefaultCommentUseCase(commentRepository: commentRepository)
        let viewModel = CommentViewModel(coordinator: self, commentUseCase: commentUseCase)
        let vc = CommentViewController.create(
            with: viewModel,
            commentId
        )
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showCommentMoreMenuBottomSheet(_ commentId: Int) {
        let commentRepository = DefaultCommentRepository(
            commentNetworkService: CommentNetworkService(),
            replyNetworkService: ReplyNetworkService()
        )
        let commentUseCase = DefaultCommentUseCase(commentRepository: commentRepository)
        let viewModel = CommentMoreMenuViewModel(coordinator: self, commentUseCase: commentUseCase)
        let view = CommentMoreMenuBottomSheet.create(with: commentId, viewModel)
        view.modalPresentationStyle = .overCurrentContext
        self.navigationController.present(view, animated: false, completion: nil)
    }
    
    func showReplyMoreMenuBottomSheet(_ replyId: Int) {
        let view = ReplyMoreMenuBottomSheet.create()
        view.modalPresentationStyle = .overCurrentContext
        self.navigationController.present(view, animated: false, completion: nil)
    }
    
    func dismissMoreMenu() {
        if let vc = self.navigationController.presentedViewController as? BottomSheetViewController {
            vc.hideBottomSheetAndGoBack {
                [weak self] in
                self?.navigationController.popViewController(animated: true)
            }
        }
    }
}

extension DefaultCommentCoordinator: UINavigationControllerDelegate {
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
