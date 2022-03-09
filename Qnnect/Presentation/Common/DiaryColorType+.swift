//
//  DiaryColorType+.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/08.
//

import UIKit

extension DiaryColorType {
    
    var color: UIColor? {
        switch self {
        case .red:
            return UIColor.diary_red
        case .pink:
            return UIColor.diary_pink
        case .yellow:
            return UIColor.diary_yellow
        case .blue:
            return UIColor.diary_blue
        }
    }
}
