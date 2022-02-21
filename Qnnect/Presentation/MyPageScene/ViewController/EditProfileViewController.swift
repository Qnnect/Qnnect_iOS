//
//  EditProfileViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/21.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class EditProfileViewController: BaseViewController {
    
    private var viewModel: EditProfileViewModel!
    
    private let profileImageView = EditProfileImageView().then {
        $0.setImage(image: Constants.profileDefaultImage)
    }
    
    private let navigationTitleView = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .GRAY01
        $0.text = "프로필 수정"
    }
    
    private let nameTextField = NameTextField().then {
        $0.textField.text = "아아메"
    }
    
    private let completionButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.backgroundColor = .GRAY04
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        $0.isEnabled = false
        $0.layer.cornerRadius = 10.0
    }
    static func create(with viewModel: EditProfileViewModel) -> EditProfileViewController {
        let vc = EditProfileViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
        [
            self.profileImageView,
            self.nameTextField,
            self.completionButton
        ].forEach {
            self.view.addSubview($0)
        }
        
        //navigation
        self.navigationItem.titleView = self.navigationTitleView
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: Constants.backBarButtonImage,
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
        

        self.view.backgroundColor = .p_ivory
        
        self.profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(108.0)
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(48.0)
        }
        
        self.nameTextField.snp.makeConstraints { make in
            make.top.equalTo(self.profileImageView.snp.bottom).offset(24.0)
            make.leading.trailing.equalToSuperview().inset(Constants.EditNameTextFieldHorizontalMargin)
        }
        
        self.nameTextField.textField.delegate = self
        
        self.completionButton.snp.makeConstraints { make in
            make.top.equalTo(self.nameTextField.snp.bottom).offset(72.0)
            make.leading.trailing.equalToSuperview().inset(Constants.bottomButtonHorizontalMargin)
            make.height.equalTo(50.0)
        }
    }
    
    override func bind() {
        
        let input = EditProfileViewModel.Input(
            inputName: self.nameTextField.textField.rx.text.orEmpty
                .asObservable()
        )
        
        let output = self.viewModel.transform(from: input)
        
        output.nameLength
            .drive(self.nameTextField.nameLengthLabel.rx.nameLength)
            .disposed(by: self.disposeBag)
        
        output.isVaildName
            .do(onNext: {
                [weak self] isValid in
                UIView.animate(withDuration: 0.5) {
                    self?.nameTextField.setCautionLabel(isValid)
                    self?.view.layoutIfNeeded()
                }
            })
            .emit(to: self.completionButton.rx.setEnabled)
            .disposed(by: self.disposeBag)
    }
}

private extension EditProfileViewController {
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - 최대 글자 수 이상 입력 제한
extension EditProfileViewController: UITextFieldDelegate {
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

import SwiftUI
struct EditProfileViewController_Priviews: PreviewProvider {
    static var previews: some View {
        Contatiner().edgesIgnoringSafeArea(.all)
    }
    struct Contatiner: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            let vc = EditProfileViewController.create(with: EditProfileViewModel(
                inputUseCase: DefaultInputUseCase(),
                coordinator: DefaultMyPageCoordinator(navigationController: UINavigationController())
            )) //보고 싶은 뷰컨 객체
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        typealias UIViewControllerType =  UIViewController
    }
}
