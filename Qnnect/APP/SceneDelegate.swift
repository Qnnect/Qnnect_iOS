//
//  SceneDelegate.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/05.
//

import UIKit
import KakaoSDKAuth
import Toast_Swift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        
        
//        KeyChain.delete(key: Constants.accessTokenKey)
//        KeyChain.delete(key: Constants.refreshTokenKey)

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.IM_Hyemin(.bold, size: 10.0)], for: .normal)
        UITabBar.appearance().tintColor = .p_brown
        UITabBar.appearance().backgroundColor = .p_ivory
        //UITabBar.appearance().isTranslucent = false

        self.scene(scene, openURLContexts: connectionOptions.urlContexts)
        
//        UserDefaults.standard.removeObject(forKey: "isFirstAccess")


    
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
                return
            }
        }
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let rootVC = UINavigationController()
        rootVC.isNavigationBarHidden = true
        
        
        self.appCoordinator = AppCoordinator(navigationController: rootVC)
        self.window = UIWindow(windowScene: windowScene)
        self.window?.backgroundColor = .p_ivory
        self.window?.rootViewController = rootVC
        self.window?.makeKeyAndVisible()
        
        
        // MARK: - DeepLink
        if let cafeCode = URLContexts.first?.url.params()?["cafeCode"] as? String {
            print("cafeCode !!! \(cafeCode)")
            
            //로그인 되어 있고 이미 화면들이 푸쉬되어 있는 상태 홈화면으로 이동후 카페 접속
            if KeyChain.read(key: Constants.accessTokenKey) != nil {
                print("login 되어있는 상태")
                if let appCoordinator = self.appCoordinator {
                    print("appCoordinator 존재")
                    if let mainCoordinator = appCoordinator.childCoordinators.first {
                        print("mainCoordinator 존재")
                        if let homeCoordinator = mainCoordinator.childCoordinators.first as? HomeCoordinator {
                            print("homeCoordinator 존재")
                            print(mainCoordinator.childCoordinators)
                            mainCoordinator.childCoordinators.forEach {
                                print("navigation viewControllers", $0.navigationController.viewControllers)
                                print("navigation presentedVC ", $0.navigationController.presentedViewController)
                                $0.navigationController.popToRootViewController(animated: false)
                                if let vc = $0.navigationController.presentedViewController {
                                    vc.presentingViewController?.dismiss(animated: false)
                                }
                            }
                            homeCoordinator.navigationController.tabBarController?.selectedIndex = 0
                            homeCoordinator.navigationController.viewControllers = []
                            print("startInviteFlow 이미 화면 구성")
                            homeCoordinator.startInviteFlow(cafeCode)
                        }
                    } else { // 로그인 되어있고 처음 앱 실행 된 상태
                        print("startInviteFlow isLogin !!!")
                        self.appCoordinator?.startInviteFlow(cafeCode)
                    }
                }
            } else {
                //splash
                print("startInviteFlow notLogin !!!")
                self.appCoordinator?.startInviteFlow(cafeCode)
            }
        } else { // 일반적인 실행
            //splash
            print("일반적인 실행")
            self.appCoordinator?.start()
        }
    }
}

