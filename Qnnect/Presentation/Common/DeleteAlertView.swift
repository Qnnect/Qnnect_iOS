//
//  DeleteAlertView.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/16.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class DeleteAlertView: BaseViewController {
    
    private let titleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .blackLabel
        $0.numberOfLines = 2
        $0.text = "삭제하시겠습니까?"
    }
    
    private let cancleButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.WHITE_FFFFFF, for: .normal)
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        $0.backgroundColor = .GRAY04
        $0.layer.cornerRadius = 10.0
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.GRAY03?.cgColor
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
    
    private let buttonStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        $0.spacing = 12.0
    }
    
    private let alertView = UIView().then {
        $0.backgroundColor = .p_ivory
        $0.layer.cornerRadius = 16.0
    }
    
    var didTapOkButton: Observable<Void> {
        return okButton.rx.tap.mapToVoid()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
        [
            cancleButton,
            okButton
        ].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        [
            titleLabel,
            buttonStackView
        ].forEach {
            alertView.addSubview($0)
        }
        
        view.addSubview(alertView)
        view.backgroundColor = .black.withAlphaComponent(0.5)
        
        alertView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(28.0)
            make.height.equalTo(180.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(44.0)
            make.centerX.equalToSuperview()
        }
        
        
        self.buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.bottom.equalToSuperview().inset(25.0)
            make.height.equalTo(50.0)
        }
    }
    
    override func bind() {
        super.bind()
        
        Observable.merge(
            cancleButton.rx.tap.asObservable(),
            okButton.rx.tap.asObservable()
        ).subscribe(onNext: {
            [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
        
        
    }
}
