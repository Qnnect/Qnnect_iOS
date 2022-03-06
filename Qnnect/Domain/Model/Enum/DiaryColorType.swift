//
//  DiartColorType.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/06.
//

import Foundation

enum DiaryColorType: String, CaseIterable, Codable {
    case red
    case pink
    case yellow
    case iceblue
    case brown
    
    var defaultImageName: String {
        switch self {
        case .red:
            return "diary_color_red"
        case  .pink:
            return "diary_color_pink"
        case  .yellow:
            return "diary_color_yellow"
        case  .iceblue:
            return "diary_color_iceblue"
        case  .brown:
            return "diary_color_brown"
        }
    }
    
    var selectedImageName: String {
        switch self {
        case .red:
            return "diary_color_red_checked"
        case .pink:
            return "diary_color_pink_checked"
        case .yellow:
            return "diary_color_yellow_checked"
        case .iceblue:
            return "diary_color_iceblue_checked"
        case .brown:
            return "diary_color_brown_checked"
        }
    }
}
