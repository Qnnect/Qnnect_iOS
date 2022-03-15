//
//  BookmarkCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/16.
//

import Foundation
import UIKit


protocol BookmarkCoordinator: Coordinator {
    func showCafeAnswerScene(_ questionId: Int, _ cafeId: Int)
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
            questionNetworkService: QuestionNetworkService()
        )
        let questionUseCase = DefaultQuestionUseCase(questionRepository: questionRepository)
        let viewModel = BookmarkViewModel(coordinator: self,questionUseCase: questionUseCase)
        let vc = BookmarkViewController.create(with: viewModel)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showCafeAnswerScene(_ questionId: Int, _ cafeId: Int) {
        let coordinator = DefaultCafeCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        self.childCoordinators.append(coordinator)
        coordinator.showCafeAnswerScene(questionId, cafeId)
    }
    
    func showBookMarkSearchScene() {
        let questionRepository = DefaultQuestionRepository(
            scrapNetworkService: ScrapNetworkService(),
            questionNetworkService: QuestionNetworkService()
        )
        let questionUseCase = DefaultQuestionUseCase(questionRepository: questionRepository)
        let viewModel = BookmarkSearchViewModel(coordinator: self, questionUseCase: questionUseCase)
        let vc = BookmarkSearchViewController.create(with: viewModel)
        self.navigationController.pushViewController(vc, animated: true)
    }
}
