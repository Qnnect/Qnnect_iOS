//
//  UIPageControl+.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/13.
//

import UIKit

extension UIPageControl {
    func hideSinglePage() {
        if self.numberOfPages == 1 {
            self.isHidden = true
        }
    }
}
