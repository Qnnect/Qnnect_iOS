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

final class LoginViewController: BaseViewController {
    
    
    private let kakaoButton = UIButton().then {
        $0.setTitle("KAKAO로 시작하기", for: .normal)
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 8.0
    }
    
    private let appleButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
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
        
        self.kakaoButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(32.0)
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.height.equalTo(self.appleButton)
        }
        
        self.appleButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.kakaoButton)
            make.top.equalTo(self.kakaoButton.snp.bottom).offset(16.0)
            make.height.equalTo(60.0)
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



