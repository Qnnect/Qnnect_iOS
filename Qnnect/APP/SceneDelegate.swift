//
//  SceneDelegate.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/05.
//

import UIKit
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let rootVC = UINavigationController()
        rootVC.isNavigationBarHidden = true
        self.appCoordinator = AppCoordinator(navigationController: rootVC)
        
        //splash
        self.appCoordinator.start()
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.IM_Hyemin(.bold, size: 10.0)], for: .normal)
        UITabBar.appearance().tintColor = .p_brown
        
        self.window = UIWindow(windowScene: windowScene)
        self.window?.backgroundColor = .p_ivory
        self.window?.rootViewController = rootVC
        self.window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
}

