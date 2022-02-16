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
import Kingfisher

final class SetProfileViewController: BaseViewController {
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 50.0
        $0.clipsToBounds = true
    }
    
    private let cameraImageView = UIImageView().then {
        $0.image = UIImage(named:"camera")
    }
    
    private let welcomeLabel = UILabel().then {
        $0.font = UIFont.IM_Hyemin(.bold, size: 20.0)
        $0.numberOfLines = 0
        var paragraphStyle = NSMutableParagraphStyle()
        //줄간격
        paragraphStyle.lineHeightMultiple = 1.23
        $0.attributedText = NSMutableAttributedString(string: "환영합니다!\n님네임을 입력해주세요", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    private let nameTextField = UITextField().then {
        $0.placeholder = Constants.nameTextFieldPlaceHolderText
        $0.layer.cornerRadius = 10.5
        $0.layer.borderWidth = 1
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20.0, height: $0.frame.height))
        $0.leftViewMode = .always
        $0.font = .IM_Hyemin(.regular, size: 14.0)
        $0.layer.borderColor = UIColor(red: 0.878, green: 0.878, blue: 0.878, alpha: 1).cgColor
    }
    
    private let completionButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.backgroundColor = .GRAY04
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        $0.isEnabled = false
        $0.layer.cornerRadius = 10.0
    }
    
    private let nameLengthLabel = UILabel().then {
        $0.text = "0/8"
        $0.textColor = .GRAY04
        $0.font = .Roboto(.regular, size: 14.0)
    }
    
    private let cautionLabel = UILabel().then {
        $0.text = "2-8글자 사이로 입력해주세요"
        $0.textColor = .red
        $0.font = .IM_Hyemin(.regular, size: 14.0)
       
    }
    
    private var viewModel: SetProfileViewModel!
    
    static func create(with viewModel: SetProfileViewModel, profileImageURL: URL?) -> SetProfileViewController {
        let vc = SetProfileViewController()
       
        vc.profileImageView.kf.setImage(
            with: profileImageURL,
            placeholder: UIImage(named: "ProfileDefaultImage")
            )
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
            self.cautionLabel,
            self.profileImageView,
            self.cameraImageView,
            self.welcomeLabel
        ].forEach {
            self.view.addSubview($0)
        }
        self.view.backgroundColor = .systemBackground
                
        self.nameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.top.equalTo(self.welcomeLabel.snp.bottom).offset(23.0)
            make.height.equalTo(50.0)
        }
        self.nameTextField.delegate = self
        
        self.completionButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.height.equalTo(Constants.bottomButtonHeight)
            make.top.equalTo(self.nameTextField.snp.bottom).offset(58.0)
        }
        
        self.nameLengthLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.nameTextField)
            make.top.equalTo(self.nameTextField.snp.bottom).offset(4.0)
        }
        
        self.cautionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameTextField.snp.bottom)
            make.leading.equalTo(self.nameTextField).offset(8.0)
            make.height.equalTo(0)
        }
        
        self.profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(100.0)
            make.top.equalToSuperview().inset(110.0)
            make.centerX.equalToSuperview()
        }
        
        self.cameraImageView.snp.makeConstraints { make in
            make.width.height.equalTo(28.0)
            make.trailing.equalTo(self.profileImageView)
            make.bottom.equalTo(self.profileImageView).inset(5.0)
        }
        
        self.welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.profileImageView.snp.bottom).offset(31.0)
            make.leading.equalToSuperview().inset(20.0)
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
        UIView.animate(withDuration: 0.5) {
            [weak self] in
            if isVaild {
                self?.cautionLabel.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
            } else {
                self?.cautionLabel.snp.updateConstraints { make in
                    make.height.equalTo(30.0)
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

import SwiftUI
struct SetProfileViewController_Priviews: PreviewProvider {
    static var previews: some View {
        Contatiner().edgesIgnoringSafeArea(.all)
    }
    struct Contatiner: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            let vc = SetProfileViewController() //보고 싶은 뷰컨 객체
            return UINavigationController(rootViewController: vc)
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        typealias UIViewControllerType =  UIViewController
    }
}
