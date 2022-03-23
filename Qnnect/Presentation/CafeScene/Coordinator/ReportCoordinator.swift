//
//  ReportCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/23.
//

import UIKit

protocol ReportCoordinator: Coordinator {
}

final class DefaultReportCoordinator: ReportCoordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = ReportBottomSheetViewModel()
        let view = ReportBottomSheet.create(with: viewModel, self)
        view.modalPresentationStyle = .overCurrentContext
        navigationController.present(view, animated: false, completion: nil)
    }
}
