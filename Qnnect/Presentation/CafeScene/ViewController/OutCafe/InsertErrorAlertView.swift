//
//  InsertErrorAlertView.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/24.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class InsertErrorAlertView: BaseViewController {
    
    private let titleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .blackLabel
        $0.numberOfLines = 2
    }
    
    private let secondaryLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 12.0)
        $0.textColor = .GRAY03
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
    
    private var message: String!
    
    static func create(
        with message: String
    ) -> InsertErrorAlertView {
        let view = InsertErrorAlertView()
        view.message = message
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
       
        
        [
            titleLabel,
            secondaryLabel,
            okButton
        ].forEach {
            self.alertView.addSubview($0)
        }
        
        self.view.addSubview(self.alertView)
        self.view.backgroundColor = .black.withAlphaComponent(0.5)
        
        self.alertView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(28.0)
            make.height.equalTo(200.0)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(25.0)
            make.centerX.equalToSuperview()
        }
        
        let paragraphStyle = Constants.paragraphStyle
        paragraphStyle.alignment = .center
        self.titleLabel.attributedText = NSAttributedString(
            string: message,
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        
        self.secondaryLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(6.0)
            make.centerX.equalToSuperview()
        }
        
        self.secondaryLabel.text = "넣은 재료는 소진됩니다."
        
        okButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.bottom.equalToSuperview().inset(25.0)
            make.height.equalTo(50.0)
        }
    }
    
    override func bind() {
        
        okButton.rx.tap
            .subscribe(onNext: {
                [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
    }
}
