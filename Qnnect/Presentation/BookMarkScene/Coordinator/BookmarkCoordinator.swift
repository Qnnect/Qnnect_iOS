//
//  BookmarkCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/16.
//

import Foundation
import UIKit


protocol BookmarkCoordinator: Coordinator {
    func showCafeQuestionScene(_ questionId: Int)
    func showBookMarkSearchScene()
}

final class DefaultBookmarkCoordinator: BookmarkCoordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let questionRepository = DefaultQuestionRepository(
            scrapNetworkService: ScrapNetworkService(),
            questionNetworkService: QuestionNetworkService(),
            likeNetworkService: LikeNetworkService()
        )
        let questionUseCase = DefaultQuestionUseCase(questionRepository: questionRepository)
        let viewModel = BookmarkViewModel(questionUseCase: questionUseCase)
        let vc = BookmarkViewController.create(with: viewModel, self)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showCafeQuestionScene(_ questionId: Int) {
        let coordinator = DefaultCafeCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        self.childCoordinators.append(coordinator)
        coordinator.showCafeQuestionScene(questionId)
    }
    
    func showBookMarkSearchScene() {
        let questionRepository = DefaultQuestionRepository(
            scrapNetworkService: ScrapNetworkService(),
            questionNetworkService: QuestionNetworkService(),
            likeNetworkService: LikeNetworkService()
        )
        let questionUseCase = DefaultQuestionUseCase(questionRepository: questionRepository)
        let viewModel = BookmarkSearchViewModel(questionUseCase: questionUseCase)
        let vc = BookmarkSearchViewController.create(with: viewModel, self)
        self.navigationController.pushViewController(vc, animated: true)
    }
}
