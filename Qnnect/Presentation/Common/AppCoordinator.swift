//
//  AppCoordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/10.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    /// rootViewController 시작 메소드
    /// - Parameter isLogin: 로그인 유무(자동로그인)
    func start(isLogin: Bool) {
        if isLogin {
            //TODO: 로그인 화면 건너뛰고 바로 홈화면으로
        } else {
            //TODO: 로그인 화면 으로
            let loginCoordinator = DefaultLoginCoordinator(navigationController: self.navigationController)
            self.childCoordinators.append(loginCoordinator)
            loginCoordinator.start()
        }
    }
}
