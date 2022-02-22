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
    static let loginTypeText = "\(UserDefaults.standard.value(forKey: "loginType") ?? "알수없음")으로 로그인하셨어요!"
    
    // MARK: - Layout
    static let nameMaxLength = 8
    static let bottomButtonHeight = 52.0
    static let profileImageWidth: CGFloat = 100.0
    static let profileImageHeight: CGFloat = 100.0
    static let pointBarHeight: CGFloat = 50.0
    
    //HomeCollectionView
    static let HomeCollectionViewHorizontalMargin: CGFloat = 10.0
    
    // Auth Flow Bottom Button
    static let bottomButtonHorizontalMargin: CGFloat = 20.0
    static let bottomButtonCornerRadius: CGFloat = 10.0
    
    //ingredentCollectionView
    static let ingredientCollectionViewHorizontalMargin: CGFloat = 20.0
    static let ingredientCellWidth: CGFloat = (UIScreen.main.bounds.width - (Constants.ingredientCollectionViewHorizontalMargin * 2.0)) / 2.0 - ingredientCellSpacing - 2.0
    static let ingredientCellHeight: CGFloat = 170.0
    static let ingredientCellSpacing: CGFloat = 8.0
    
    //tag
    static let tagCornerRadius: CGFloat = 44.0
    static let tagExtraSpace: CGSize = CGSize(width: 24.0, height: 20.0) // 여백
    static let tagBorderWidth: CGFloat = 1.0
    static let tagCollectionViewHorizontalInset: CGFloat = 20.0
    
    //tag+pointBar
    static let tagBetweenPointBarSpace: CGFloat = 17.0
    
    //Home CollectionView Cell
    static let homeCellCornerRadius: CGFloat = 16.0
    
    //MyPage
    static let myPageProfileImageWidth: CGFloat = 60.0
    static let myPageProfileImageHeight: CGFloat = 60.0
    static let myPageCornerRadius: CGFloat = 16.0
    
    //EditNameTextField
    static let EditNameTextFieldHorizontalMargin: CGFloat = 20.0
    
    // MARK: - Image
    static let profileDefaultImage: UIImage? = UIImage(named: "ProfileDefaultImage")
    static let cameraImage: UIImage? = UIImage(named: "camera")
    static let pointImage: UIImage? = UIImage(named: "kong")
    static let notificationIcon: UIImage? = UIImage(named: "notification")
    static let priceImage: UIImage? = UIImage(named: "price")
    static let groupPlusImage: UIImage? = UIImage(named: "group_plus")
    
    //navigation Bar
    static let store_navigation_bar_icon: UIImage? = UIImage(named:"store_navigation_bar_icon")
    static let backBarButtonImage: UIImage? = UIImage(named:"backBarButtonImage")
    static let xmarkImage: UIImage? = UIImage(named: "X_mark")
    // MARK: - BarButton
    static let navigationLeftPadding: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil).then {
        $0.width = 18.0
    }
}
