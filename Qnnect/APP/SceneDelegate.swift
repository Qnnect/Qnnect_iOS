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
        
        //TODO: 자동로그인 로직 구현, 테스트를 위해 하드코딩
        self.appCoordinator.start(isLogin: false)
        
        self.window = UIWindow(windowScene: windowScene)
        self.window?.backgroundColor = .systemBackground
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

