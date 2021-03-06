//
//  TermsViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/14.
//

import UIKit
import SnapKit
import Then
import RxGesture
import RxSwift
import SafariServices

final class TermsViewController: BaseViewController {
    
    private let titleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 20.0)
        $0.numberOfLines = 0
        $0.textColor = .GRAY01
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.23
        $0.attributedText = NSMutableAttributedString(string: Constants.TermsSceneTitle, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
    private let dividingLine = UIView().then {
        $0.layer.borderWidth = 1.01
        $0.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
    }
    
    private let allAgreementView = AgreementItemView(type: .all)
    private let personalInfoAgreementView = AgreementItemView(type: .personal)
    private let serviceAgreementView = AgreementItemView(type: .service)
    private let pushNotiAgreementView = AgreementItemView(type: .pushnoti)
    
    private let agreementStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.axis = .vertical
        $0.spacing = 8.0
    }
    
    private let agreementButton = UIButton().then {
        $0.setTitle("동의합니다", for: .normal)
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        $0.backgroundColor = .GRAY04
        $0.layer.cornerRadius = Constants.bottomButtonCornerRadius
        $0.isEnabled = false
    }
    
    private let backButton = UIButton().then {
        $0.setImage(Constants.backBarButtonImage, for: .normal)
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.contentInsets = .init(top: 0, leading: Constants.leftImageInset.left, bottom: 0, trailing: 0)
            $0.configuration = config
        } else {
            $0.imageEdgeInsets = Constants.leftImageInset
        }
        
    }
    weak var coordinator: AuthCoordinator?
    private var viewModel: TermsViewModel!
    private var token: Token!
    private var loginType: LoginType!
    private var inviteCode: String?
    
    static func create(
        with viewModel: TermsViewModel,
        _ token: Token,
        _ loginType: LoginType,
        _ coordinator: AuthCoordinator,
        _ inviteCode: String?
    ) -> TermsViewController {
        let vc = TermsViewController()
        vc.viewModel = viewModel
        vc.token = token
        vc.loginType = loginType
        vc.coordinator = coordinator
        vc.inviteCode = inviteCode
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func configureUI() {
        
        [
            self.titleLabel,
            self.allAgreementView,
            self.dividingLine,
            self.agreementStackView,
            self.agreementButton
        ].forEach {
            self.view.addSubview($0)
        }
        
        [
            self.personalInfoAgreementView,
            self.serviceAgreementView,
            self.pushNotiAgreementView
        ].forEach {
            self.agreementStackView.addArrangedSubview($0)
        }
            
        
        self.backButton.snp.makeConstraints { make in
            make.width.height.equalTo(48.0)
        }
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(21.0)
            make.top.equalToSuperview().inset(60.0).priority(.low)
            make.bottom.equalTo(allAgreementView.snp.top).offset(-18.0)
        }
        
        self.allAgreementView.snp.makeConstraints { make in
            make.bottom.equalTo(dividingLine).offset(-8.0)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48.0)
        }
        
        self.dividingLine.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32.0)
            make.centerY.equalToSuperview().offset(-60.0)
            make.height.equalTo(1.0)
        }
        
        self.agreementStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.dividingLine.snp.bottom).offset(28.0)
            make.height.equalTo(160.0)
        }
        
        self.agreementButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.bottom.equalToSuperview().inset(58.0)
            make.height.equalTo(Constants.bottomButtonHeight)
        }
    }
    
    override func bind() {
        let items = Observable.combineLatest(
            self.personalInfoAgreementView.checkBox.rx.tap
                .scan(false, accumulator: { last, new in
                    !last
                }).do(onNext: {
                    [weak self] flag in
                    self?.personalInfoAgreementView.checkBox.isSelected = flag
                })
                .startWith(false)
            ,
            self.serviceAgreementView.checkBox.rx.tap
                .scan(false, accumulator: { last, new in
                    !last
                }).do(onNext: {
                    [weak self] flag in
                    self?.serviceAgreementView.checkBox.isSelected = flag
                }).startWith(false),
            self.pushNotiAgreementView.checkBox.rx.tap
                .scan(false, accumulator: { last, new in
                    !last
                }).do(onNext: {
                    [weak self] flag in
                    self?.pushNotiAgreementView.checkBox.isSelected = flag
                }).startWith(false)
                ) {
                (personal:$0, service: $1, pushNoti: $2)
                }
        
        let input = TermsViewModel.Input(
            didTapAgreementButton: self.agreementButton.rx.tap
                .asObservable(),
            didCheckAllAgreement: self.allAgreementView.checkBox.rx.tap
                .map{
                    [weak self] _ in
                    guard let self = self else { return false}
                    return !self.allAgreementView.checkBox.isSelected
                },
            checkeditem: items,
            token: Observable.just(self.token),
            loginType: Observable.just(self.loginType),
            inviteCode: Observable.just(inviteCode).compactMap { $0 }
        )
        
        let output = self.viewModel.transform(from: input)
        
        output.isCompletedAgreement
            .emit(onNext: self.setAgreementButton(_:))
            .disposed(by: self.disposeBag)
        
        output.isAllAgreement
            .emit(onNext: self.setAllAgreementCheckBox(_:))
            .disposed(by: self.disposeBag)
        
        output.isCheckedAllAgreement
            .emit(onNext: self.sendActionCheckBoxes(_:))
            .disposed(by: self.disposeBag)
        
        guard let coordinator = coordinator else { return }
        
        output.start
            .emit(onNext: coordinator.showSetProfileScene)
            .disposed(by: self.disposeBag)
        
        output.inviteFlowNextScene
            .emit(onNext: coordinator.showSetProfileScene)
            .disposed(by: self.disposeBag)
        
        personalInfoAgreementView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: {
                [weak self] _ in
                let safari = SFSafariViewController(url: URL(string: APP.personalInfoProcessingPolicyURL)!)
                self?.present(safari, animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
        
        serviceAgreementView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: {
                [weak self] _ in
                let safari = SFSafariViewController(url: URL(string: APP.termsOfUseURL)!)
                self?.present(safari, animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
    }
}

private extension TermsViewController {
    func setAgreementButton(_ isCompleted: Bool) {
        self.agreementButton.backgroundColor = isCompleted ? .p_brown : .GRAY04
        self.agreementButton.isEnabled = isCompleted
    }
    
    func setAllAgreementCheckBox(_ isAllAgreed: Bool) {
        self.allAgreementView.checkBox.isSelected = isAllAgreed
    }
    
    func sendActionCheckBoxes(_ isAllAgreed: Bool) {
        self.agreementStackView.arrangedSubviews.forEach {
            let view = $0 as? AgreementItemView
            if view?.checkBox.isSelected != isAllAgreed {
                view?.checkBox.sendActions(for: .touchUpInside)
            }
        }
    }
}
