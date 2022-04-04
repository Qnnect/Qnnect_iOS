//
//  EnterErrorAlertView.swift
//  Qnnect
//
//  Created by 재영신 on 2022/04/04.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class ErrorAlertView: BaseViewController {
    
    private let titleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .blackLabel
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }

    
    private(set) var okButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.WHITE_FFFFFF, for: .normal)
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        $0.backgroundColor = .p_brown
        $0.layer.cornerRadius = 10.0
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.BLACK_121212?.cgColor
    }
    
    private var message: String!
    
    static func create(with message: String) -> ErrorAlertView {
        let vc = ErrorAlertView()
        vc.message = message
        return vc
    }
    
    private let alertView = UIView().then {
        $0.backgroundColor = .p_ivory
        $0.layer.cornerRadius = 16.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
        [
            titleLabel,
            okButton
        ].forEach {
            self.alertView.addSubview($0)
        }
        
        self.view.addSubview(self.alertView)
        self.view.backgroundColor = .black.withAlphaComponent(0.5)
        
        self.alertView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(28.0)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(45.0)
            make.leading.trailing.equalToSuperview().inset(16.0)
        }
        
        let paragraphStyle = Constants.paragraphStyle
        paragraphStyle.alignment = .center
        titleLabel.attributedText = NSMutableAttributedString(
            string: message,
            attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle]
        )
        
        okButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.bottom.equalToSuperview().inset(30.0)
            make.top.equalTo(titleLabel.snp.bottom).offset(35.0)
            make.height.equalTo(50.0)
        }
    }
    
    override func bind() {
        super.bind()
        
        okButton.rx.tap
            .subscribe(onNext: {
                [weak self] _ in
                let pvc = self?.presentingViewController as? UINavigationController
                self?.dismiss(animated: true, completion: {
                    pvc?.popViewController(animated: true)
                })
            }).disposed(by: self.disposeBag)
        
        
    }
}
