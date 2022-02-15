//
//  TermsViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/14.
//

import UIKit
import SnapKit
import Then

final class TermsViewController: BaseViewController {
    
    private let titleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 20.0)
        $0.numberOfLines = 0
        $0.textColor = .GRAY01
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.23
        $0.attributedText = NSMutableAttributedString(string: "시작 전에\n약관에 동의해주세요", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
    private let dividingLine = UIView().then {
        $0.layer.borderWidth = 1.01
        $0.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
    }
    
    private let allAgreementView = AgreementItemView(type: .all).then {
        $0.update(with: "네, 모두 동의합니다.")
    }
    
    private let personalInfoAgreementView = AgreementItemView(type: .essential).then {
        $0.update(with: "개인정보 처리방침")
    }
    
    private let serviceAgreementView = AgreementItemView(type: .essential).then {
        $0.update(with: "서비스 이용약관")
    }
    
    private let pushNotiAgreementView = AgreementItemView(type: .choice).then {
        $0.update(with: "푸쉬 알림 동의 여부")
    }
    
    private let agreementStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.axis = .vertical
        $0.spacing = 8.0
    }
    private let agreementButton = UIButton().then {
        $0.setTitle("동의합니다", for: .normal)
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        $0.backgroundColor = .GRAY04
        $0.layer.cornerRadius = 10.0
    }
    
    private var viewModel: TermsViewModel!
    
    static func create(with viewModel: TermsViewModel) -> TermsViewController {
        let vc = TermsViewController()
        vc.viewModel = viewModel
        return vc 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(21.0)
            make.top.equalToSuperview().inset(194.0)
        }
        
        self.allAgreementView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(31.0)
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
        let input = TermsViewModel.Input(
            didTapStartButton: self.agreementButton.rx.tap
                .asObservable()
                .mapToVoid()
        )
        
        let output = self.viewModel.transform(from: input)
        output.start
            .emit()
            .disposed(by: self.disposeBag)
    }
}
