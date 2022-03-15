//
//  NotBuyAlertViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/15.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class NotBuyAlertViewController: BaseViewController {
    
    private let titleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .blackLabel
        $0.numberOfLines = 2
        $0.attributedText = NSAttributedString(
            string: "포인트가 부족하여\n재료를 구매할 수 없습니다",
            attributes: [NSAttributedString.Key.paragraphStyle: Constants.paragraphStyle]
        )
    }
    

    private let okButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.WHITE_FFFFFF, for: .normal)
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        $0.backgroundColor = .p_brown
        $0.layer.cornerRadius = 10.0
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.BLACK_121212?.cgColor
    }
    
    
    private let alertView = UIView().then {
        $0.backgroundColor = .p_ivory
        $0.layer.cornerRadius = 16.0
    }
    
    static func create() -> NotBuyAlertViewController {
        let view = NotBuyAlertViewController()
        return view
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
        
        view.addSubview(alertView)
        view.backgroundColor = .black.withAlphaComponent(0.5)
        
        alertView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(28.0)
            make.height.equalTo(195.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40.0)
            make.centerX.equalToSuperview()
        }
        
        okButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(18.0)
            make.bottom.equalToSuperview().inset(18.0)
            make.height.equalTo(50.0)
        }
    }
    
    override func bind() {
        super.bind()
        
        okButton.rx.tap
            .subscribe(onNext: {
                [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
    }
}
