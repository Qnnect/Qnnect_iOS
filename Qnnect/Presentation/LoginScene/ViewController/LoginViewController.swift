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


class LeftAlignButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        contentHorizontalAlignment = .left
        let availableSpace = bounds.inset(by: contentEdgeInsets)
        let availableWidth = availableSpace.width - imageEdgeInsets.right - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: availableWidth / 2 - 15, bottom: 0, right: 0)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 0)
    }
}


//TODO: 소셜 로그인 후 서버로 부터 존재해 있는 유저인지 확인 후 회원가입,로그인 진행
final class LoginViewController: BaseViewController {
    
    private let loginBackgroundView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = Constants.loginPageImage
    }
    
    private let secondaryLabel = UILabel().then {
        
        $0.text = "공유 Q&A 다이어리 서비스, 큐넥트"
    }
    private let kakaoButton = LeftAlignButton().then {
        $0.setImage(Constants.kakaoLogo?.with(.init(top: 0, left: 5.0, bottom: 0, right: 0)), for: .normal)
        $0.setTitle("카카오로 로그인", for: .normal)
        $0.setTitleColor(.black.withAlphaComponent(0.85), for: .normal)
        $0.backgroundColor = .kakaoContainer
        $0.layer.cornerRadius = 10.0
        $0.titleLabel?.font = .systemFont(ofSize: 22.36, weight: .regular)
        $0.contentHorizontalAlignment = .left
        $0.imageView?.contentMode = .scaleAspectFit
        $0.contentHorizontalAlignment = .fill
    }
    
    
    //TODO: Apple Login button custom
///    private let appleButton = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
    private let appleButton = LeftAlignButton().then {

//        let pointSize: CGFloat = 52.0
//        let imageConfig = UIImage.SymbolConfiguration(pointSize: pointSize)

       // $0.setImage(resizeImage(image: Constants.appleLogo!, targetHeight: 52.0), for: .normal)
        $0.setImage(Constants.appleLogo, for: .normal)
        $0.setTitle("Apple로 로그인", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10.0

        $0.titleLabel?.font = .Roboto(.regular, size: 22.36) // 22.36
        $0.contentHorizontalAlignment = .left
        //$0.contentVerticalAlignment = .fill
    }
    
    
    private var viewModel: LoginViewModel!
    weak var coordinator: AuthCoordinator?
    private var inviteCode: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func create(
        with viewModel: LoginViewModel,
        _ coordinator: AuthCoordinator,
        _ inviteCode: String?
    ) -> LoginViewController {
        let vc = LoginViewController()
        vc.viewModel = viewModel
        vc.coordinator = coordinator
        vc.inviteCode = inviteCode
        return vc
    }
    
    override func configureUI() {
        
        [
            self.loginBackgroundView,
            self.kakaoButton,
            self.appleButton
        ].forEach {
            self.view.addSubview($0)
        }
        
        
        self.loginBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.kakaoButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.bottomButtonHorizontalMargin)
            make.height.equalTo(52.0)
            make.bottom.equalTo(appleButton.snp.top).offset(-8.0)
        }
        
        self.appleButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(110.0)
            make.leading.trailing.height.equalTo(self.kakaoButton)
            make.height.equalTo(52.0)
        }
    }
    
    override func bind() {
        let input = LoginViewModel.Input(
            didTapKakaoButton: self.kakaoButton.rx.tap.mapToVoid(),
            didTapAppleButton: self.appleButton.rx.tap.mapToVoid(),
            inviteCode: Observable.just(inviteCode).compactMap { $0 }
        )
        
        let output = self.viewModel.transform(from: input)
        
        guard let coordinator = coordinator else { return }
        output.showHomeScene
            .emit(onNext: coordinator.showMain)
            .disposed(by: self.disposeBag)
        
        output.showTermsScene
            .emit(onNext: coordinator.showTermsVC)
            .disposed(by: self.disposeBag)
        
        output.inviteFlowTermScene
            .emit(onNext: coordinator.showTermsVC)
            .disposed(by: self.disposeBag)
        
        output.inviteFlowHomeScene
            .emit(onNext: coordinator.showMain(inviteCode:))
            .disposed(by: self.disposeBag
            )
    }
    
}


extension Reactive where Base: ASAuthorizationAppleIDButton{
    
    /// Reactive wrapper for `TouchUpInside` control event.
    public var tap: ControlEvent<Void> {
        controlEvent(.touchUpInside)
    }
}



