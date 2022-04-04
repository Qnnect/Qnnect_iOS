//
//  Constants.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/14.
//

import Foundation
import UIKit
import RxSwift

struct Constants {
    private init() { }
    
    // MARK: - Text
    static let nameTextFieldPlaceHolderText = "닉네임 (2~\(Constants.nameMaxLength)자 이하)"
    static let nameInputCaution = "닉네임은 2~8자 이하입니다"
    static let firstProfileSetSceneTitle = "환영합니다!\n닉네임을 입력해주세요"
    static let TermsSceneTitle = "시작 전에\n약관에 동의해주세요"
    static let loginTypeText = "\(UserDefaults.standard.value(forKey: "loginType") ?? "알수없음")으로 로그인하셨어요!"
    static let titleCaution = "제목은 2~10자 이하입니다"
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
    
    //bottom Sheet
    static let bottomSheetHorizontalMargin: CGFloat = 20.0
    
    //Cafe Answer
    static let answerCellHeight: CGFloat = 135.0
    static let answerCellSpacing: CGFloat = 17.0
    
    // MARK: - Image
    static let profileDefaultImage: UIImage? = UIImage(named: "ProfileDefaultImage")
    static let cameraImage: UIImage? = UIImage(named: "camera")
    static let pointImage: UIImage? = UIImage(named: "kong")
    static let notificationIcon: UIImage? = UIImage(named: "notification")?.withRenderingMode(.alwaysOriginal)
    static let notification_unread: UIImage? = UIImage(named: "notification_unread")?.withRenderingMode(.alwaysOriginal)
    static let priceImage: UIImage? = UIImage(named: "pointIcon")
    static let groupPlusImage: UIImage? = UIImage(named: "group_plus")
    static let notSelectDrinkImage: UIImage? = UIImage(named: "notSelectDrinkImage")?.withRenderingMode(.alwaysOriginal)
    static let basicDrinkImage: UIImage? = UIImage(named: "basic_drink")?.withRenderingMode(.alwaysOriginal)
    static let navigationMenuImage: UIImage? = UIImage(named: "navi_menu")?.withRenderingMode(.alwaysOriginal)
    static let navigationRecipeImage: UIImage? = UIImage(named: "navi_recipe")?.withRenderingMode(.alwaysOriginal)
    static let cafeinvitationDrinkImage: UIImage? = UIImage(named: "초대음료이미지")?.withRenderingMode(.alwaysOriginal)
    static let splashImage: UIImage? = UIImage(named: "splash")?.withRenderingMode(.alwaysOriginal)
    static let loginPageImage: UIImage? = UIImage(named: "loginPage")?.withRenderingMode(.alwaysOriginal)
    static let onboardingImage1: UIImage? = UIImage(named: "onboarding1")?.withRenderingMode(.alwaysOriginal)
    static let onboardingImage2: UIImage? = UIImage(named: "onboarding2")?.withRenderingMode(.alwaysOriginal)
    static let onboardingImage3: UIImage? = UIImage(named: "onboarding3")?.withRenderingMode(.alwaysOriginal)
    static let onboardingImage4: UIImage? = UIImage(named: "onboarding4")?.withRenderingMode(.alwaysOriginal)
    static let commentIcon: UIImage? = UIImage(named: "comment")?.withRenderingMode(.alwaysOriginal)
    static let attachingImageIcon: UIImage? = UIImage(named: "bottom_camera")?.withRenderingMode(.alwaysOriginal)
    static let attacingCancleButtonIcon: UIImage? = UIImage(named: "attacingCancleButtonIcon")?.withRenderingMode(.alwaysOriginal)
    static let navigationHeartIcon: UIImage? = UIImage(named: "navigation_heart")?.withRenderingMode(.alwaysOriginal)
    static let navigationCheckedHeartIcon: UIImage? = UIImage(named: "navigation_heart_checked")?.withRenderingMode(.alwaysOriginal)
    static let navigationScrapIcon: UIImage? = UIImage(named: "navigation_scrap")?.withRenderingMode(.alwaysOriginal)
    static let navigationCheckedScrapIcon: UIImage? = UIImage(named: "navigation_scrap_checked")?.withRenderingMode(.alwaysOriginal)
    static let commentEmptyImage: UIImage? = UIImage(named: "comment_empty")?.withRenderingMode(.alwaysOriginal)
    static let reply_arrow_icon: UIImage? = UIImage(named: "reply_arrow")?.withRenderingMode(.alwaysOriginal)
    static let more_icon: UIImage? = UIImage(named: "more_icon")
    static let sendButtonImage: UIImage? = UIImage(named: "sendButtonImage")?.withRenderingMode(.alwaysOriginal)
    static let answer_writing_icon: UIImage? = UIImage(named: "answer_writing_icon")?.withRenderingMode(.alwaysOriginal)
    
    //navigation Bar
    static let store_navigation_bar_icon: UIImage? = UIImage(named:"store_navigation_bar_icon")?.withRenderingMode(.alwaysOriginal)
    static let backBarButtonImage: UIImage? = UIImage(named:"backBarButtonImage")?.withAlignmentRectInsets(.init(top: -12.0, left: -12.0, bottom: 0.0, right: 0))
    static let xmarkImage: UIImage? = UIImage(named: "X_mark")
    static let leftImageInset: UIEdgeInsets = .init(top: -12.0, left: -12.0, bottom: 0.0, right: 0)
    static let navigation_search: UIImage? = UIImage(named: "navigation_search")?.withRenderingMode(.alwaysOriginal)
    static let navagation_more: UIImage? = UIImage(named: "navi_more")?.withRenderingMode(.alwaysOriginal)
    static let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle().then {
        $0.lineHeightMultiple = 1.17
        $0.lineBreakStrategy = .hangulWordPriority
    }
    static let navi_store: UIImage? = UIImage(named: "navi_store")?.withRenderingMode(.alwaysOriginal)
    
    //login Button logo
    static let appleLogo: UIImage? = UIImage(named: "appleLogo")?.withRenderingMode(.alwaysOriginal)
    static let kakaoLogo: UIImage? = UIImage(named: "kakaoLogo")?.withRenderingMode(.alwaysOriginal)
    
    //DrinkProgressBar
    static let drinkProgressBar_step_0: UIImage? = UIImage(named: "drinkProgressBar_step_0")
    static let drinkProgressBar_step_1: UIImage? = UIImage(named: "drinkProgressBar_step_1")
    static let drinkProgressBar_step_2: UIImage? = UIImage(named: "drinkProgressBar_step_2")
    static let drinkProgressBar_step_3: UIImage? = UIImage(named: "drinkProgressBar_step_3")
    static let drinkRecipeProgressBar: UIImage? = UIImage(named: "drinkRecipeProgressBar")
    
    
    static let completionCelebrateImage: UIImage? = UIImage(named: "음료완성축하이미지")
    static let invitationImage: UIImage? = UIImage(named: "초대이미지")
    static let listEmptyImage: UIImage? = UIImage(named: "listEmptyImage")
    static let addCafeImage: UIImage? = UIImage(named: "addCafeImage")
    static let floatingButtonImage: UIImage? = UIImage(named: "floatingButton")
    static let completionTwinkle: UIImage? = UIImage(named: "completionTwinkle")
    static let drinkShadow: UIImage? = UIImage(named: "drinkShadow")
    static let stampDefaultImage: UIImage? = UIImage(named: "stampDefaultImage")
    
    // MARK: -  Drinks
    static let drinkEmptyImage: UIImage? = UIImage(named: "drink_empty")
    static let drinkIceStepImage: UIImage? = UIImage(named: "drink_ice_common")
    //딸기라떼
    static let strawberryLatte_step_1: UIImage? = UIImage(named: "딸기라떼_step_1")
    static let strawberryLatte_step_2: UIImage? = UIImage(named: "딸기라떼_step_2")
    static let strawberryLatte_step_3: UIImage? = UIImage(named: "딸기라떼_step_3")
    static let strawberryLatte_step_4: UIImage? = UIImage(named: "딸기라떼_step_4")
    
    // 레몬 에이드
    static let lemonade_step_1: UIImage? = UIImage(named: "레몬에이드_step_1")
    static let lemonade_step_2: UIImage? = UIImage(named: "레몬에이드_step_2")
    static let lemonade_step_3: UIImage? = UIImage(named: "레몬에이드_step_3")
    static let lemonade_step_4: UIImage? = UIImage(named: "레몬에이드_step_4")
    
    // 민트초코
    static let mintChoco_step_1: UIImage? = UIImage(named: "민트초코_step_1")
    static let mintChoco_step_2: UIImage? = UIImage(named: "민트초코_step_2")
    static let mintChoco_step_3: UIImage? = UIImage(named: "민트초코_step_3")
    static let mintChoco_step_4: UIImage? = UIImage(named: "민트초코_step_4")
    
    // 썸머라떼
    static let summerLatte_step_1: UIImage? = UIImage(named: "썸머라떼_step_1")
    static let summerLatte_step_2: UIImage? = UIImage(named: "썸머라떼_step_2")
    static let summerLatte_step_3: UIImage? = UIImage(named: "썸머라떼_step_3")
    static let summerLatte_step_4: UIImage? = UIImage(named: "썸머라떼_step_4")
    
    // 초코 라뗴
    static let chocoLatte_step_1: UIImage? = UIImage(named: "초코라떼_step_1")
    static let chocoLatte_step_2: UIImage? = UIImage(named: "초코라떼_step_2")
    static let chocoLatte_step_3: UIImage? = UIImage(named: "초코라떼_step_3")
    static let chocoLatte_step_4: UIImage? = UIImage(named: "초코라떼_step_4")
    
    
    //Notification
    static let noti_question_icon: UIImage? = UIImage(named: "noti_question_icon")
    static let noti_comment_icon: UIImage? = UIImage(named: "noti_comment_icon")
    static let noti_reply_icon: UIImage? = UIImage(named: "noti_reply_icon")
    static let noti_question_read_icon: UIImage? = UIImage(named: "noti_question_read_icon")
    static let noti_comment_read_icon: UIImage? = UIImage(named: "noti_comment_read_icon")
    static let noti_reply_read_icon: UIImage? = UIImage(named: "noti_reply_read_icon")
    
    // MARK: - BarButton
    static let navigationLeftPadding: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil).then {
        $0.width = 18.0
    }
    
    // MARK: - Key
    static let accessTokenKey: String = "accessToken"
    static let refreshTokenKey: String = "refreshToken"
    
    static let scrapFetchSize: Int = 10
}
