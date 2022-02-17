//
//  Constants.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/14.
//

import Foundation
import UIKit

struct Constants {
    private init() { }
    
    // MARK: - Text
    static let nameTextFieldPlaceHolderText = "닉네임 (2~\(Constants.nameMaxLength)자 이하)"
    static let nameInputCaution = "2-8글자 사이로 입력해주세요"
    static let firstProfileSetSceneTitle = "환영합니다!\n님네임을 입력해주세요"
    static let TermsSceneTitle = "시작 전에\n약관에 동의해주세요"
    
    // MARK: - Layout
    static let nameMaxLength = 8
    static let bottomButtonHeight = 52.0
    static let profileImageWidth: CGFloat = 100.0
    static let profileImageHeight: CGFloat = 100.0
    static let pointBarHeight: CGFloat = 50.0
    
    //tag
    static let tagCornerRadius: CGFloat = 44.0
    static let tagExtraSpace: CGSize = CGSize(width: 24.0, height: 20.0) // 여백
    static let tagBorderWidth: CGFloat = 1.0
    
    // MARK: - Image
    static let profileDefaultImage: UIImage? = UIImage(named: "ProfileDefaultImage")
    static let cameraImage: UIImage? = UIImage(named: "camera")
    static let pointImage: UIImage? = UIImage(named: "kong")
    static let notificationIcon: UIImage? = UIImage(named: "notification")
    static let priceImage: UIImage? = UIImage(named: "price")
    
}
