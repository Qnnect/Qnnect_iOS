//
//  AddGroupViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/21.
//

import UIKit
import SnapKit
import Then

final class AddGroupViewController: BaseViewController {
    
    // 바텀 시트 뷰
    private let bottomSheetView = UIView().then {
        $0.backgroundColor = .p_ivory
        $0.layer.cornerRadius = 24.0
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupGestureRecognizer()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showBottomSheet()
    }
    
    override func configureUI() {
        
        self.view.addSubview(self.bottomSheetView)
        self.view.backgroundColor = .black.withAlphaComponent(0.5)
        
        self.bottomSheetView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
    }
    
}

private extension AddGroupViewController {
    // 바텀 시트 표출 애니메이션
    func showBottomSheet() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.bottomSheetView.snp.updateConstraints { make in
                make.height.equalTo(self.view.frame.height - 86.0)
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // 바텀 시트 사라지는 애니메이션
    func hideBottomSheetAndGoBack() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.bottomSheetView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    func setupGestureRecognizer() {
        // 흐린 부분 탭할 때, 바텀시트를 내리는 TapGesture
        let tapGestue = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        self.view.addGestureRecognizer(tapGestue)
        self.view.isUserInteractionEnabled = true
        
        
    }
    
    
    // UITapGestureRecognizer 연결 함수 부분
    @objc func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
    }
}
