//
//  InputNameViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/14.
//

import UIKit
import Then
import SnapKit
import RxSwift

final class SetProfileViewController: BaseViewController {
    private let nameTextField = UITextField().then {
        $0.placeholder = Constants.nameTextFieldPlaceHolderText
    }
    
    private let completionButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.backgroundColor = .p_brown
        $0.setTitleColor(.black, for: .normal)
        $0.isEnabled = false
    }
    
    private let nameLengthLabel = UILabel().then {
        $0.text = "0/8"
    }
    
    private let cautionLabel = UILabel().then {
        $0.text = "2-8글자 사이로 입력해주세요"
        $0.textColor = .red
    }
    private var viewModel: SetProfileViewModel!
    
    static func create(with viewModel: SetProfileViewModel) -> SetProfileViewController {
        let vc = SetProfileViewController()
        vc.viewModel = viewModel
        return vc
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
        //TODO: 테스트를 위한 제약조건, 나중에 변경
        [
            self.nameTextField,
            self.completionButton,
            self.nameLengthLabel,
            self.cautionLabel
        ].forEach {
            self.view.addSubview($0)
        }
        
        self.nameTextField.delegate = self
        
        self.nameTextField.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        self.completionButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(100.0)
            make.width.height.equalTo(100.0)
        }
        
        self.nameLengthLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.nameTextField)
            make.top.equalTo(self.nameTextField.snp.bottom)
        }
        
        self.cautionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameTextField.snp.bottom).offset(8.0)
            make.centerX.equalToSuperview()
            make.height.equalTo(0)
        }
    }
    
    override func bind() {
        let input = SetProfileViewModel.Input(
            inputName: self.nameTextField.rx.text
                .asObservable()
                .skip(while: { ($0?.count ?? 0) == 0}),
            didTapCompletionButton: self.completionButton.rx.tap.withLatestFrom(self.nameTextField.rx.text.asObservable())
                .compactMap{ $0 }
        )
        
        let output = self.viewModel.transform(from: input)
        
        
        //Rx+/UIBUtton+
        output.isValidName
            .do(onNext: self.setCautionLabel(_:))
            .drive(self.completionButton.rx.setEnabled)
            .disposed(by: self.disposeBag)
        
        //Rx+/UILabel+
        output.nameLength
            .drive(self.nameLengthLabel.rx.nameLength)
            .disposed(by: self.disposeBag)
        
        output.completion
            .emit()
            .disposed(by: self.disposeBag)
    }
}

private extension SetProfileViewController {
    func setCautionLabel(_ isVaild: Bool) {
        UIView.animate(withDuration: 1.0) {
            [weak self] in
            if isVaild {
                self?.cautionLabel.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
            } else {
                self?.cautionLabel.snp.updateConstraints { make in
                    make.height.equalTo(50.0)
                }
            }
            self?.view.layoutIfNeeded()
        }
    }
}
// MARK: - 최대 글자 수 이상 입력 제한
extension SetProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let max = Constants.nameMaxLength
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        guard textField.text!.count < max else { return false }
        return true
    }
}
