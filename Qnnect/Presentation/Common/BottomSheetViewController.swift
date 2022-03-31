//
//  BottomSheetViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import UIKit
import SnapKit

protocol BottomSheetable: AnyObject {
    var dimmendView: UIView { get }
    var bottomSheetView: UIView { get }
    var dismissButton: UIButton { get }
}
class BottomSheetViewController: BaseViewController, BottomSheetable {
    
    // 바텀 시트 뷰
    let bottomSheetView = UIView().then {
        $0.backgroundColor = .p_ivory
        $0.layer.cornerRadius = 24.0
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
    
    let dimmendView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    let dismissButton = UIButton().then {
        $0.setImage(Constants.xmarkImage, for: .normal)
    }
    
    let titleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .GRAY01
    }
    
    var topPadding: CGFloat = 0
    
    override func viewDidLoad() {
        [
            self.dimmendView,
            self.bottomSheetView,
        ].forEach {
            self.view.addSubview($0)
        }
        
       [
            self.dismissButton,
            self.titleLabel
       ].forEach {
           self.bottomSheetView.addSubview($0)
       }
        
        self.dimmendView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.bottomSheetView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
        
        self.dismissButton.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(8.0)
            make.width.height.equalTo(48.0)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.dismissButton)
        }
        
        
        dismissButton.rx.tap
            .mapToVoid()
            .subscribe(onNext: {
                [weak self] _ in
                self?.hideBottomSheetAndGoBack(nil)
            }
            )
            .disposed(by: self.disposeBag)
        
        self.setupGestureRecognizer()
        super.viewDidLoad()
        self.view.backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let navigationVC = presentingViewController as? UINavigationController {
            navigationVC.viewControllers.last?.viewWillAppear(true)
            if navigationVC.viewControllers.last is HomeViewController || navigationVC.viewControllers.last is CafeRoomViewController {
                presentingViewController?.tabBarController?.tabBar.isHidden = false
            }
        } else {
            presentingViewController?.viewWillAppear(true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showBottomSheet()
    }
    
    // 바텀 시트 표출 애니메이션
    func showBottomSheet() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.bottomSheetView.snp.updateConstraints { make in
                make.height.equalTo(self.view.frame.height - self.topPadding)
            }
            self.presentingViewController?.tabBarController?.tabBar.isHidden = true
            self.view.layoutIfNeeded()
        }) { _ in
            
        }
    }
    
    // 바텀 시트 사라지는 애니메이션
    func hideBottomSheetAndGoBack(_ completion:(() -> Void)?) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.bottomSheetView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            self.view.endEditing(true)
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: completion)
            }
        }
    }
    
    func setupGestureRecognizer() {
        // 흐린 부분 탭할 때, 바텀시트를 내리는 TapGesture
        let tapGestue = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        self.dimmendView.addGestureRecognizer(tapGestue)
        self.dimmendView.isUserInteractionEnabled = true
    }
    
    // UITapGestureRecognizer 연결 함수 부분
    @objc func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheetAndGoBack(nil)
    }
}


          
