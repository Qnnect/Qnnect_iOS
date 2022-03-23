//
//  WriteCommentCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/16.
//

import UIKit

protocol WriteCommentCoordinator: Coordinator {
    func start(_ question: Question, _ user: User?, _ comment: Comment?)
    func pop()
}

final class DefaultWriteCommentCoordinator: WriteCommentCoordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func start(_ question: Question, _ user: User?, _ comment: Comment? = nil) {
        let commentRepository = DefaultCommentRepository(
            commentNetworkService: CommentNetworkService(),
            replyNetworkService: ReplyNetworkService()
        )
        let commentUseCase = DefaultCommentUseCase(commentRepository: commentRepository)
        let viewModel = WriteCommentViewModel(commentUseCase: commentUseCase)
        let vc = WriteCommentViewController.create(
            with: question,
            user,
            viewModel,
            self,
            comment
        )
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
}

