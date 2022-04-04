//
//  AppDelegate.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/05.
//

import UIKit
import Firebase
import FirebaseMessaging
import KakaoSDKCommon
import KakaoSDKUser
import AuthenticationServices
import Photos

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let userDefaultManager = DefaultUserDefaultManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        self.registerRemoteNotification()
        
        
        // KAKAO
        KakaoSDK.initSDK(appKey: APP.KAKAO_NATIVE_APP_KEY)
        
        // 앱 재설치 시 저장된 토크 정보 삭제
        if userDefaultManager.isFirstLaunch == nil {
            userDefaultManager.isFirstLaunch = false
            KeyChain.delete(key: Constants.accessTokenKey)
            KeyChain.delete(key: Constants.refreshTokenKey)
        }
        
        //FCM 현재 등록 토큰 확인
        Messaging.messaging().token { token, error in
            if let error = error {
                print("ERROR FCM 등록토큰 가져오기: \(error.localizedDescription)")
            } else if let token = token {
                print("FCM TOKEN : \(token)")
            }
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

private extension AppDelegate {
    func registerRemoteNotification() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        center.requestAuthorization(options: options) { granted, _ in
            // APNs에 device token 등록 요청
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    //Foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("will Present Noti")
        completionHandler([.list, .banner, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        //TODO: 푸시알림 응답 처리
        let userInfo = response.notification.request.content.userInfo
        print("Push Noti!!!")
        print(userInfo)
        handlePushNoti()
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else { return }
        print("FCM 등록토큰 갱신: \(token)")
    }
}


private extension AppDelegate {
    func handlePushNoti() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        
        //로그인 되어 있고 이미 화면들이 푸쉬되어 있는 상태 홈화면으로 이동후 카페 접속
        if KeyChain.read(key: Constants.accessTokenKey) != nil {
            print("login 되어있는 상태")
            if let appCoordinator = sceneDelegate.appCoordinator {
                print("appCoordinator 존재")
                if let mainCoordinator = appCoordinator.childCoordinators.first {
                    print("mainCoordinator 존재")
                    if let homeCoordinator = mainCoordinator.childCoordinators.first as? HomeCoordinator {
                        print("homeCoordinator 존재")
                        print(mainCoordinator.childCoordinators)
                        mainCoordinator.childCoordinators.forEach {
                            $0.navigationController.popToRootViewController(animated: false)
                            if let vc = $0.navigationController.presentedViewController {
                                vc.presentingViewController?.dismiss(animated: false)
                            }
                        }
                        homeCoordinator.navigationController.tabBarController?.selectedIndex = 0
                        homeCoordinator.navigationController.popToRootViewController(animated: true)
                        print("이미 화면 구성")
                        NotificationCenter.default.post(name: .didTapPushNoti, object: nil)
                    }
                } 
            }
        }
    }
}

extension Notification.Name {
    static let didTapPushNoti = Notification.Name("didTapPushNoti")
}
