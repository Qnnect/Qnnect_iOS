//
//  OnboardingSceneType.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/30.
//

import UIKit

enum OnboardingSceneType: CaseIterable {
    case question
    case connection
    case drink
    case stamp
    
    var mainTitle: String {
        switch self {
        case .question:
            return "나를 알아가는 질문"
        case .connection:
            return "가족/친구/커플간의\nQ&A 공유를 통한 소통"
        case .drink:
            return "나만의 음료 만들기"
        case .stamp:
            return "스탬프 - 내가 만든 음료 모아보기"
        }
    }
    
    var secondaryTitle: String {
        switch self {
        case .question:
            return "큐넥트 지킴이 넥트가\n여러분에게 단 하나의 질문을 드려요\nQ&A를 통해 나를 알아가고 일상을 회고해보세요!"
        case .connection:
            return "Q&A를 가족/친구/커플끼리 공유하여 서로에\n대해 알아가고 소통할 수 있어요!\n기본 제공 질문 외에 카페 멤버에게 하고싶은 질문을 직접 추가할 수도 있어요\n(큐넥트에서 카페란, 다이어리 그룹을 의미해요️)"
        case .drink:
            return "답변을 달거나 질문을 추가할수록 쌓이는\n원두 포인트를 통해\n나만의 음료를 만들어보세요"
        case .stamp:
            return "음료를 완성할 때마다 스탬프가 음료로 채워져요\n스탬프를 멋지게 채워보세요!"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .question:
            return Constants.onboardingImage1
        case .connection:
            return Constants.onboardingImage2
        case .drink:
            return Constants.onboardingImage3
        case .stamp:
            return Constants.onboardingImage4
        }
    }
    
}
