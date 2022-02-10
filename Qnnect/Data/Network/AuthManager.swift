//
//  LoginManager.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/10.
//

import Foundation
import RxKakaoSDKUser
import KakaoSDKUser
import RxSwift

protocol AuthManager {
    func kakaoLogin() -> Observable<Bool>
    func appleLogin()
}

final class DefaultAuthManager: AuthManager {
    func kakaoLogin() -> Observable<Bool> {
    
        if (UserApi.isKakaoTalkLoginAvailable()) {
            return UserApi.shared.rx.loginWithKakaoTalk()
                .map{
                    token -> Bool in
                    //TODO: token 서버로 전송,로컬 저장
                    return true
                }.catchAndReturn(false)
                
        } else {
          return UserApi.shared.rx.loginWithKakaoAccount(prompts: [.Login])
                .map{
                    token -> Bool in
                    //TODO: token 서버로 전송,로컬 저장
                    return true
                }.catchAndReturn(false)
        }                               
    }
    
    func appleLogin() {
        
    }
}
