//
//  ModifyQuestionCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/04/02.
//

import UIKit

protocol ModifyQuestionCoordinator: Coordinator {
    func start(_ question: Question)
    func pop()
}

final class DefaultModifyQuestionCoordinator: ModifyQuestionCoordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func start(_ question: Question) {
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


