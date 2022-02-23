//
//  SplashViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import UIKit
import SnapKit
import Then
import Photos

final class SplashViewController: BaseViewController {
    
    private let testLabel = UILabel().then {
        $0.text = "Splash"
        $0.font = .BM_JUA(size: 28.0)
        $0.textColor = .GRAY01
    }
    
    static func create() -> SplashViewController {
        let vc = SplashViewController()
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        self.view.addSubview(testLabel)
        
        self.testLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.7)
        }
            
        

        PHPhotoLibrary.requestAuthorization( { status in
                    switch status{
                    case .authorized:
                        print("Album: 권한 허용")
                    case .denied:
                        print("Album: 권한 거부")
                    case .restricted, .notDetermined:
                        print("Album: 선택하지 않음")
                    default:
                        break
                    }
        })
        
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        if status == .notDetermined || status == .restricted || status == .denied {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        
    }
}
