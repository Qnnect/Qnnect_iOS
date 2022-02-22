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
    
    private let editProfileImageView = EditProfileImageView()
    
    private let welcomeLabel = UILabel().then {
        $0.font = UIFont.IM_Hyemin(.bold, size: 20.0)
        $0.numberOfLines = 0
        var paragraphStyle = NSMutableParagraphStyle()
        //줄간격
        paragraphStyle.lineHeightMultiple = 1.23
        $0.attributedText = NSMutableAttributedString(string: Constants.firstProfileSetSceneTitle, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
    private let completionButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.backgroundColor = .GRAY04
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        $0.isEnabled = false
        $0.layer.cornerRadius = 10.0
    }

    private let nameTextField = NameTextField().then {
        $0.textField.placeholder = Constants.nameTextFieldPlaceHolderText
    }
    
    private let cautionLabel = UILabel().then {
        $0.text = Constants.nameInputCaution
        $0.textColor = .red
        $0.font = .IM_Hyemin(.regular, size: 14.0)
        
    }
    
    private lazy var imagePickController: UIImagePickerController = {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        return controller
    }()
    
    private lazy var bottomSheet: UIAlertController = {
        let sheet = UIAlertController(title: "프로필 사진 설정", message: nil, preferredStyle: .actionSheet)
        let galleryAction = UIAlertAction(title: "앨범에서 사진 선택", style: .default) { _ in
            self.present(self.imagePickController, animated: true, completion: nil)
        }
        let defaultImageAction = UIAlertAction(title: "기본 이미지로 변경", style: .default) { _ in
            self.editProfileImageView.setImage(image: Constants.profileDefaultImage)
        }
        
        let cancelAction = UIAlertAction(title:"취소",style: .cancel)
        sheet.addAction(galleryAction)
        sheet.addAction(defaultImageAction)
        sheet.addAction(cancelAction)
        return sheet
    }()
    
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
            self.editProfileImageView,
            self.welcomeLabel
        ].forEach {
            self.view.addSubview($0)
        }
        
        self.imagePickController.delegate = self
        
        self.nameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.EditNameTextFieldHorizontalMargin)
            make.top.equalTo(self.welcomeLabel.snp.bottom).offset(23.0)
        }
        self.nameTextField.textField.delegate = self
        
        self.completionButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.nameTextField)
            make.height.equalTo(Constants.bottomButtonHeight)
            make.top.equalTo(self.nameTextField.snp.bottom).offset(58.0)
        }
        
        
        self.editProfileImageView.snp.makeConstraints { make in
            make.width.equalTo(Constants.profileImageWidth)
            make.height.equalTo(Constants.profileImageHeight)
            make.top.equalToSuperview().inset(110.0)
            make.centerX.equalToSuperview()
        }
        
        self.welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.editProfileImageView.snp.bottom).offset(31.0)
            make.leading.equalToSuperview().inset(20.0)
        }
        
    }
    
    override func bind() {
        
        
        let input = SetProfileViewModel.Input(
            inputName: self.nameTextField.textField.rx.text
                .asObservable()
                .skip(while: { ($0?.count ?? 0) == 0}),
            didTapCompletionButton: self.completionButton.rx.tap.withLatestFrom(self.nameTextField.textField.rx.text.asObservable())
                .compactMap{ $0 },
            viewDidLoad: Observable.just(())
        )
        
        let output = self.viewModel.transform(from: input)
        
        
        //Rx+/UIBUtton+
        output.isValidName
            .do(onNext: {
                [weak self] isValid in
                UIView.animate(withDuration: 0.5) {
                    self?.nameTextField.setCautionLabel(isValid)
                    self?.view.layoutIfNeeded()
                }
            })
            .drive(self.completionButton.rx.setEnabled)
            .disposed(by: self.disposeBag)
        
        //Rx+/UILabel+
        output.nameLength
                .drive(self.nameTextField.nameLengthLabel.rx.nameLength)
            .disposed(by: self.disposeBag)
        
        output.completion
            .emit()
            .disposed(by: self.disposeBag)
        
        output.profileImageURL
            .drive(onNext:self.setProfileImageView)
            .disposed(by: self.disposeBag)
                
        self.editProfileImageView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: {
                [weak self] _ in
                guard let self = self else { return }
                self.present(self.bottomSheet, animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
    }
}

private extension SetProfileViewController {
    func setProfileImageView(_ url: URL?) {
        self.editProfileImageView.setImage(url: url)
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

extension SetProfileViewController: UIImagePickerControllerDelegate&UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var newImage: UIImage? = nil // update 할 이미지
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage // 수정된 이미지가 있을 경우
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage // 원본 이미지가 있을 경우
        }
        
        self.editProfileImageView.setImage(image: newImage) // 받아온 이미지를 update
        picker.dismiss(animated: true, completion: nil) // picker를 닫아줌
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
