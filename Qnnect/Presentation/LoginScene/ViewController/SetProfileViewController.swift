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
        $0.backgroundColor = .PRIMARY01
        $0.setTitleColor(.black, for: .normal)
        $0.isEnabled = false
    }
    
    private let nameLengthLabel = UILabel().then {
        $0.text = "0/8"
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
            self.nameLengthLabel
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
            make.trailing.equalTo(nameTextField)
            make.top.equalTo(nameTextField.snp.bottom)
        }
    }
    
    override func bind() {
        let input = SetProfileViewModel.Input(
            inputName: self.nameTextField.rx.text.asObservable(),
            didTapCompletionButton: self.completionButton.rx.tap.withLatestFrom(self.nameTextField.rx.text.asObservable())
                .compactMap{ $0 }
        )
        
        let output = self.viewModel.transform(from: input)
        
        
        //Rx+/UIBUtton+
        output.isValidName
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
