//
//  LoginViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/10.
//

import UIKit
import SnapKit
import Then
import AuthenticationServices
import RxSwift
import RxCocoa
import CryptoKit

//TODO: 소셜 로그인 후 서버로 부터 존재해 있는 유저인지 확인 후 회원가입,로그인 진행
final class LoginViewController: BaseViewController {
    
    private let kakaoButton = UIButton().then {
        $0.setImage(UIImage(named: "kakao_login_large_wide"), for: .normal)
    }
    
    //TODO: Apple Login button custom
    private let appleButton = ASAuthorizationAppleIDButton(authorizationButtonType: .continue, authorizationButtonStyle: .white)
    
    private var viewModel: LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    static func create(with viewModel: LoginViewModel) -> LoginViewController {
        let vc = LoginViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func configureUI() {
        
        [
            self.kakaoButton,
            self.appleButton
        ].forEach {
            self.view.addSubview($0)
        }
        
        self.view.backgroundColor = .p_brown
        
        
        self.kakaoButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.height.equalTo(Constants.bottomButtonHeight)
        }
        
        self.appleButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(110.0)
            make.top.equalTo(self.kakaoButton.snp.bottom).offset(8.0)
            make.leading.trailing.height.equalTo(self.kakaoButton)
            
        }
    }
    
    override func bind() {
        let input = LoginViewModel.Input(
            didTapKakaoButton: self.kakaoButton.rx.tap.mapToVoid(),
            didTapAppleButton: self.appleButton.rx.tap.mapToVoid()
        )
        
        let output = self.viewModel.transform(from: input)
        output.isSuccess.emit(
            onNext: {
                print($0)
            }
        ).disposed(by: self.disposeBag)
    }
    
}


extension Reactive where Base: ASAuthorizationAppleIDButton{
    
    /// Reactive wrapper for `TouchUpInside` control event.
    public var tap: ControlEvent<Void> {
        controlEvent(.touchUpInside)
    }
}



