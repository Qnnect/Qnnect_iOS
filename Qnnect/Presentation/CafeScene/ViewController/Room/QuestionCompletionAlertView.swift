//
//  QuestionCompletionAlertView.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/16.
//

import UIKit
import SnapKit
import Then
import RxSwift

enum QuestionCompletionBehaviorType {
    case goCafe
    case goMyQuestion
}

final class QuestionCompletionAlertView: BaseViewController {
    
    private let titleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .blackLabel
        $0.numberOfLines = 2
    }
    
    private let secondaryLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 12.0)
        $0.textColor = .GRAY03
        $0.text = "등록된 질문은 다음 주기에 전달됩니다"
    }
    
    private let goCafeRoomButton = UIButton().then {
        $0.setTitle("카페로 가기", for: .normal)
        $0.setTitleColor(.p_brown, for: .normal)
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        $0.backgroundColor = .p_ivory
        $0.layer.cornerRadius = 10.0
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.secondaryBorder?.cgColor
    }
    
    private let goMyQuestionButton = UIButton().then {
        $0.setTitle("내 질문보기", for: .normal)
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
    
    private var viewModel: QuestionCompletionAlertViewModel!
    weak var coordinator: CafeCoordinator?
    
    static func create(
        with viewModel: QuestionCompletionAlertViewModel,
        _ coordinator: CafeCoordinator
    ) -> QuestionCompletionAlertView {
        let view = QuestionCompletionAlertView()
        view.viewModel = viewModel
        view.coordinator = coordinator
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
        [
            goCafeRoomButton,
            goMyQuestionButton
        ].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        [
            titleLabel,
            secondaryLabel,
            buttonStackView
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
            make.top.equalToSuperview().inset(25.0)
            make.leading.trailing.equalToSuperview().inset(33.0)
        }
        
        let paragraphStyle = Constants.paragraphStyle
        paragraphStyle.alignment = .center
        self.titleLabel.attributedText = NSAttributedString(
            string: "내 질문이 등록되었습니다\n질문은 마이페이지에서 볼 수 있습니다",
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        
        self.secondaryLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(6.0)
            make.centerX.equalToSuperview()
        }
        
        self.buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.bottom.equalToSuperview().inset(25.0)
            make.height.equalTo(50.0)
        }
    }
    
    override func bind() {
      
        let input = QuestionCompletionAlertViewModel.Input(
            didTapGoCafeRoomButton: goCafeRoomButton.rx.tap.asObservable(),
            didTapGoMyQuestionButton: goMyQuestionButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(from: input)
        
        guard let coordinator = coordinator else { return }

        output.showCafeRoomScene
            .emit(onNext: coordinator.dismissQuestionCompletionAlertView(_:))
            .disposed(by: self.disposeBag)
        
        output.showMyQustionScene
            .emit(onNext: coordinator.dismissQuestionCompletionAlertView(_:))
            .disposed(by: self.disposeBag)
    }
}

