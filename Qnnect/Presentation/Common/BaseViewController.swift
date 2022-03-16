//
//  BaseViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/06.
//

import UIKit
import RxSwift
import PhotosUI

class BaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .p_ivory
        
        let barAppearance = self.navigationController?.navigationBar.standardAppearance
        barAppearance?.shadowColor = UIColor.black.withAlphaComponent(0.08)
        barAppearance?.backgroundColor = .p_ivory
        barAppearance?.setBackIndicatorImage(Constants.backBarButtonImage, transitionMaskImage: Constants.backBarButtonImage)
        self.navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
        self.navigationController?.navigationBar.compactAppearance = barAppearance
        
        let backBarButton = UIBarButtonItem()
        backBarButton.title = ""
        self.navigationItem.backBarButtonItem = backBarButton
        
        hideKeyboard()
        self.configureUI()
        self.bind()
    }
    
    func configureUI() {
        
    }
    
    func bind() {
        
    }
    
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap(sender:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            view.endEditing(true) // todo...
        }
        sender.cancelsTouchesInView = false
    }
    
    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func checkPermission(selectionLimit: Int = 1, _ isShowGallery: Bool){
        if PHPhotoLibrary.authorizationStatus() == .authorized || PHPhotoLibrary.authorizationStatus() == .limited{ // authorized -> 사용자가 명시적으로 권한 부여 , limited -> 사용자가 이 앱에 제한된 권한을 승인 (선택한 몇개 만 사용 하겠다)
            if isShowGallery {
                DispatchQueue.main.async {
                    self.showGallery(selectionLimit)
                }
            }
        }else if PHPhotoLibrary.authorizationStatus() == .denied{ //승인 거절 했을 경우
            DispatchQueue.main.async {
                self.showAuthorizationDeniedAlert()
            }
        }else if PHPhotoLibrary.authorizationStatus() == .notDetermined{ // 사용자가 앱의 인증상태를 설정하지 않은 경우 ex) 앱을 설치하고 처음 실행
            PHPhotoLibrary.requestAuthorization { status in
                self.checkPermission(false)
            }
        }
    }
    
    func showGallery(_ selectionLimit: Int){
        let library = PHPhotoLibrary.shared() //singleton pattern
        var configuration = PHPickerConfiguration(photoLibrary: library)
        configuration.selectionLimit = selectionLimit
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func showAuthorizationDeniedAlert(){
        let alert = UIAlertController(title: "포토라이브러리의 접근 권환을 활성화 해주세요.", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "설정으로 가기", style: .default, handler: { action in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(url){
                UIApplication.shared.open(url, options: [:],completionHandler: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePicker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
    }
}

extension BaseViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        self.imagePicker(picker, didFinishPicking: results)
    }
    
    
}
