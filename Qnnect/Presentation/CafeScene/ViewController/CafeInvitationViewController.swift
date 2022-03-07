//
//  CafeinvitationViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/07.
//

import UIKit
import SnapKit
import Then

final class CafeInvitationViewController: BaseViewController {
    
    private let mainLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .BLACK_121212
        $0.text = "초대하기"
    }
    
    private let secondaryLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 12.0)
        $0.textColor = .GRAY03
        $0.numberOfLines = 2
        $0.attributedText = NSAttributedString(
            string: "함께 다이어리를 작성할 \n 친구를 초대해보세요 (최대 5명)",
            attributes: [NSAttributedString.Key.paragraphStyle: Constants.paragraphStyle]
        )
    }
    
    private let invitationCardView = UIView().then {
        $0.backgroundColor = .PINK01
        $0.layer.cornerRadius = 25.0
        $0.layer.borderWidth = 1.05
        $0.layer.borderColor = UIColor.brownBorderColor?.cgColor
    }
    
    private let invitationCardBackgroundView = UIView().then {
        $0.backgroundColor = .SECONDARY01
        $0.layer.cornerRadius = 25.0
        $0.layer.borderWidth = 1.05
        $0.layer.borderColor = UIColor.brownBorderColor?.cgColor
    }
    
    private let cardTitleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 20.0)
        $0.textAlignment = .center
        $0.textColor = .BLACK_121212
        $0.text = "★초대장★"
    }
    
    private let cardMainLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 20.0)
        $0.textColor = .BLACK_121212
        $0.numberOfLines = 2
        let paragraphStyle = Constants.paragraphStyle
        paragraphStyle.alignment = .left
        $0.attributedText = NSAttributedString(
            string: "신사고 5인방 카페에 \n초대합니다!",
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
    }
    
    private let cardSecondaryLabel = UILabel().then {
        $0.font = .IM_Hyemin(.regular, size: 16.0)
        $0.textColor = .BLACK_121212
        $0.text = "(당신은 선택받은 자)"
    }
    
    private let cardDrinkImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = Constants.cafeinvitationDrinkImage
    }
    
    private let invitaionLinkCopyButton = UIButton().then {
        $0.setTitle("초대링크 복사", for: .normal)
        $0.setTitleColor(.BLACK_121212, for: .normal)
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        $0.layer.cornerRadius = 10.0
        $0.layer.borderWidth = 1.2
        $0.layer.borderColor = UIColor.secondaryBorder?.cgColor
    }
    
    private let kakaoInvitationButton = UIButton().then {
        $0.setTitle("카카오톡 초대", for: .normal)
        $0.setTitleColor(.BLACK_121212, for: .normal)
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        $0.layer.cornerRadius = 10.0
        $0.layer.borderWidth = 1.2
        $0.layer.borderColor = UIColor.secondaryBorder?.cgColor
    }
    
    private let buttonStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.spacing = 17.0
    }
    
    static func create() -> CafeInvitationViewController{
        let vc = CafeInvitationViewController()
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func configureUI() {
        
        [
            self.invitaionLinkCopyButton,
            self.kakaoInvitationButton
        ].forEach {
            self.buttonStackView.addArrangedSubview($0)
        }
        
        [
            self.mainLabel,
            self.secondaryLabel,
            self.invitationCardBackgroundView,
            self.invitationCardView,
            self.buttonStackView
        ].forEach {
            self.view.addSubview($0)
        }
        
        [
            self.cardTitleLabel,
            self.cardMainLabel,
            self.cardSecondaryLabel,
            self.cardDrinkImageView
        ].forEach {
            self.invitationCardView.addSubview($0)
        }
        
        self.mainLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(self.view.safeAreaLayoutGuide).inset(20.0)
        }
        
        self.secondaryLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.mainLabel)
            make.top.equalTo(self.mainLabel.snp.bottom).offset(10.0)
        }
        
        self.invitationCardBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(self.invitationCardView)
        }
        
        self.invitationCardBackgroundView.transform = .init(rotationAngle: CGFloat.pi + 0.1)
        
        self.invitationCardView.snp.makeConstraints { make in
            make.top.equalTo(self.secondaryLabel.snp.bottom).offset(33.0)
            make.leading.trailing.equalToSuperview().inset(26.0)
        }
        
        self.buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(self.invitationCardView.snp.bottom).offset(48.0)
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.height.equalTo(Constants.bottomButtonHeight)
        }
        
        self.cardTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(25.0)
            make.centerX.equalToSuperview()
        }
        
        self.cardMainLabel.snp.makeConstraints { make in
            make.top.equalTo(self.cardTitleLabel.snp.bottom).offset(18.0)
            make.leading.trailing.equalToSuperview().inset(26.0)
        }
        
        self.cardSecondaryLabel.snp.makeConstraints { make in
            make.top.equalTo(self.cardMainLabel.snp.bottom).offset(2.0)
            make.leading.trailing.equalTo(self.cardMainLabel)
        }
        
        self.cardDrinkImageView.snp.makeConstraints { make in
            make.top.equalTo(self.cardSecondaryLabel.snp.bottom).offset(5.0)
            make.trailing.equalToSuperview().inset(16.0)
            make.bottom.equalToSuperview().inset(24.0)
            make.width.equalTo(130.0)
        }
    }
    
    override func bind() {
        
    }
}
