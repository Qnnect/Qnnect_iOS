//
//  TodayQuestionFooterView.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import UIKit
import SnapKit
import Then

final class PageControlFooterView: UICollectionReusableView {
    static let identifier = "PageControlFooterView"
    
    private(set) var pageControl = UIPageControl().then {
        $0.pageIndicatorTintColor = .GRAY04
        $0.currentPageIndicatorTintColor = .p_brown
        $0.hidesForSinglePage = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    private func configureUI() {
        self.addSubview(self.pageControl)
        
        self.pageControl.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
