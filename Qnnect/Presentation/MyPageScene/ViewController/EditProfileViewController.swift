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
import PhotosUI

final class EditProfileViewController: BaseViewController {
    
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
    
    private lazy var bottomSheet: UIAlertController = {
        let sheet = UIAlertController(title: "프로필 사진 설정", message: nil, preferredStyle: .actionSheet)
        let galleryAction = UIAlertAction(title: "앨범에서 사진 선택", style: .default) { _ in
            self.checkPermission(true)
        }
        let defaultImageAction = UIAlertAction(title: "기본 이미지로 변경", style: .default) { _ in
            self.profileImageView.setImage(image: Constants.profileDefaultImage)
        }
        
        let cancelAction = UIAlertAction(title:"취소",style: .cancel)
        sheet.addAction(galleryAction)
        sheet.addAction(defaultImageAction)
        sheet.addAction(cancelAction)
        return sheet
    }()
    
    private var viewModel: EditProfileViewModel!
    weak var coordinator: MyPageCoordinator?
    private var user: User!
    
    static func create(
        with viewModel: EditProfileViewModel,
        _ user: User,
        _ coordinator: MyPageCoordinator
    ) -> EditProfileViewController {
        let vc = EditProfileViewController()
        vc.viewModel = viewModel
        vc.user = user
        vc.coordinator = coordinator
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
        
        self.view.backgroundColor = .p_ivory
        
        self.profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(108.0)
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(48.0)
        }
        
        if let url = user.profileImage {
            self.profileImageView.setImage(url: URL(string: url))
        } else {
            self.profileImageView.setImage(image: Constants.profileDefaultImage)
        }
        
        
        
        self.nameTextField.snp.makeConstraints { make in
            make.top.equalTo(self.profileImageView.snp.bottom).offset(24.0)
            make.leading.trailing.equalToSuperview().inset(Constants.EditNameTextFieldHorizontalMargin)
        }
        
        self.nameTextField.textField.delegate = self
        self.nameTextField.textField.text = self.user.name
        
        self.completionButton.snp.makeConstraints { make in
            make.top.equalTo(self.nameTextField.snp.bottom).offset(72.0)
            make.leading.trailing.equalToSuperview().inset(Constants.bottomButtonHorizontalMargin)
            make.height.equalTo(50.0)
        }
    }
    
    override func bind() {
        
        let input = EditProfileViewModel.Input(
            inputName: self.nameTextField.textField.rx.text.orEmpty
                .asObservable(),
            didTapProfileImageView: self.profileImageView.rx.tapGesture()
                .when(.recognized)
                .mapToVoid(),
            didTapCompletionButton: self.completionButton.rx.tap
                .asObservable(),
            profileImage: self.profileImageView.imageData,
            user: Observable.just(self.user)
        )
        
        let output = self.viewModel.transform(from: input)
        
        output.nameLength
            .drive(self.nameTextField.nameLengthLabel.rx.nameLength)
            .disposed(by: self.disposeBag)
        
        output.isVaildName
            .do{
                [weak self] isValid in
                UIView.animate(withDuration: 0.5) {
                    self?.nameTextField.setCautionLabel(isValid)
                    self?.view.layoutIfNeeded()
                }
            }
            .emit(to: self.completionButton.rx.setEnabled)
            .disposed(by: self.disposeBag)
        
        output.showBottomSheet
            .emit(onNext: self.showBottomSheet)
            .disposed(by: self.disposeBag)
        
        guard let coordinator = coordinator else { return }

        output.pop
            .emit(onNext: coordinator.pop)
            .disposed(by: self.disposeBag)
    }
    
    override func imagePicker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard results.count != 0 else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        let identifiers = results.map{ $0.assetIdentifier ?? ""}
        let result = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
        let imageManager = PHImageManager()
        let scale = UIScreen.main.scale
        let imageSize = CGSize(width: 108 * scale, height: 108 * scale)
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.resizeMode = .none
        imageManager.requestImage(for: result[0], targetSize: imageSize, contentMode: .aspectFill, options: options) { image, info in
            if (info?[PHImageResultIsDegradedKey] as? Bool) == true{
           }else{
               //고화질
               self.profileImageView.setImage(image: image)
           }
        }
        self.dismiss(animated: true, completion: nil)
    }
}

private extension EditProfileViewController {
    func showBottomSheet() {
        self.present(self.bottomSheet, animated: true, completion: nil)
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

