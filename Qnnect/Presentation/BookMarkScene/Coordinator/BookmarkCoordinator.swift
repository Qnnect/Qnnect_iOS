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

final class DefaultBookmarkCoordinator: NSObject, BookmarkCoordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
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

extension DefaultBookmarkCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // 이동 전 ViewController
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
           return
        }

        // child coordinator 가 일을 끝냈다고 알림.
        if let vc = fromViewController as? CafeQuestionViewController {
            childDidFinish(vc.coordinator)
            print("TEst!@#!@#")
            if let presentedVC = navigationController.viewControllers.last {
                presentedVC.tabBarController?.tabBar.isHidden = false
            }
        }
        
        if let vc = fromViewController as? CommentViewController {
            childDidFinish(vc.coordinator)
            if let presentedVC = navigationController.viewControllers.last {
                presentedVC.tabBarController?.tabBar.isHidden = false
            }
        }
        
        if let vc = fromViewController as? WriteCommentViewController {
            childDidFinish(vc.coordinator)
            if let presentedVC = navigationController.viewControllers.last {
                presentedVC.tabBarController?.tabBar.isHidden = false
            }
        }
    }
}
