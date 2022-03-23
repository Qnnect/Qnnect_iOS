//
//  ReportCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/23.
//

import UIKit
import MessageUI


protocol ReportCoordinator: Coordinator {
}

final class DefaultReportCoordinator: ReportCoordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func start(_ reportUser: User) {
        let viewModel = ReportBottomSheetViewModel()
        if let delegate = navigationController.viewControllers.last! as? MFMailComposeViewControllerDelegate{
            let view = ReportBottomSheet.create(with: viewModel, self, reportUser, delegate)
            view.modalPresentationStyle = .overCurrentContext
            navigationController.present(view, animated: false, completion: nil)
        }
    }
}
