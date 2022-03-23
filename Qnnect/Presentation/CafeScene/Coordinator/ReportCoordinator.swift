//
//  ReportCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/23.
//

import UIKit
import MessageUI


protocol ReportCoordinator: Coordinator {
    func dismiss()
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
        let reportRepository = DefaultReportRepository(reportNetworkService: ReportNetworkService())
        let reportUseCase = DefaultReportUseCase(reportRepository: reportRepository)
        let viewModel = ReportBottomSheetViewModel(reportUseCase: reportUseCase)
        if let delegate = navigationController.viewControllers.last! as? MFMailComposeViewControllerDelegate{
            let view = ReportBottomSheet.create(with: viewModel, self, reportUser, delegate)
            view.modalPresentationStyle = .overCurrentContext
            navigationController.present(view, animated: false, completion: nil)
        }
    }
    
    func dismiss() {
        navigationController.presentedViewController?.dismiss(animated: false, completion: nil)
    }
}
