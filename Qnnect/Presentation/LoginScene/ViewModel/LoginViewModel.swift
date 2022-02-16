//
//  LoginViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/10.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel: ViewModelType {
    
    struct Input {
        let didTapKakaoButton: Observable<Void>
        let didTapAppleButton: Observable<Void>
    }
    
    struct Output {
        let isSuccess: Signal<URL?>
    }
    
    var loginManager: LoginManager!
    private weak var coordinator: LoginCoordinator?
    
    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(from input: Input) -> Output {
        let kakaoLogin = input.didTapKakaoButton
            .compactMap(self.loginManager.kakaoLogin)
            .flatMap{ $0 }
        
        let appleLoginSuccess = input.didTapAppleButton
            .compactMap(self.loginManager.appleLogin)
            .flatMap{ $0 }
            .filter{ $0 }
            .map{ URL(string: $0.description) } // 애플 로그인은 사진을 가져 올수 없기 때문에 nil을 반환
        
        let kakaoLoginSuccess = kakaoLogin.filter { $0 }
            .mapToVoid()
            .flatMap(self.loginManager.getUserProfileImageInKakao)
            
        // TODO: 소셜 로그인 후 서버로 토큰을 전송해 기존에 존재해 있는 회원인지 확인 후 분기 처리
        let isSuccess = Observable.merge(kakaoLoginSuccess,appleLoginSuccess)
            .do(onNext :{ [weak self] url in
                self?.coordinator?.showInputNameVC(profileImageURL: url)
            })
                
        return Output(
            isSuccess: isSuccess.asSignal(onErrorJustReturn: nil)
        )
    }
}
