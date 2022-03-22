//
//  WrongStepAlertView.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/18.
//

import UIKit
import SnapKit
import Then

final class WrongStepAlertView: BaseViewController {
    
    private let titleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .blackLabel
        $0.numberOfLines = 2
        $0.attributedText = NSAttributedString(
            string: "잘못된 재료입니다.\n다른 재료를 넣어주세요",
            attributes: [NSAttributedString.Key.paragraphStyle: Constants.paragraphStyle]
        )
    }
    
    private let secondaryLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 12.0)
        $0.textColor = .GRAY03
        $0.text = "테스트 문구"
        $0.textAlignment = .center
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
    
    private var wrongType: InsertWrongType!
    static func create(with wrongType: InsertWrongType) -> WrongStepAlertView {
        let view = WrongStepAlertView()
        view.wrongType = wrongType
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
            alertView.addSubview($0)
        }
        
        view.addSubview(alertView)
        view.backgroundColor = .black.withAlphaComponent(0.5)
        
        alertView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(28.0)
            make.height.equalTo(200.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            //make.top.equalToSuperview().inset(25.0)
            make.centerY.equalToSuperview().multipliedBy(0.585)
            make.centerX.equalToSuperview()
        }
        
        secondaryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8.0)
            make.centerX.equalToSuperview()
        }
        
        okButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.bottom.equalToSuperview().inset(30.0)
            make.height.equalTo(50.0)
        }
        
        setLabelsLayout(wrongType)
    }
    
    override func bind() {
        super.bind()
        
        okButton.rx.tap
            .subscribe(onNext: {
                [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
    }
        
    private func setLabelsLayout(_ wrongType: InsertWrongType) {
        switch wrongType {
        case .forward(let curStep):
            secondaryLabel.isHidden = true
            titleLabel.text = "\(curStep.title)을 넣을 단계에요."
        case .backward(let curStep, let ingredientName):
            titleLabel.attributedText = NSMutableAttributedString(
                string: "\(DrinkStep(rawValue: curStep.rawValue - 1)?.title ?? "")까지 완성해서\n\(ingredientName)은 더 넣으실 수 없어요.",
                attributes: [NSAttributedString.Key.paragraphStyle: Constants.paragraphStyle]
            )
            secondaryLabel.text = "\(curStep.title)을 넣어주세요"
        }
    }
}
