//
//  StoreViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/16.
//

import UIKit
import SnapKit
import Then
import KakaoSDKCommon
import TTGTags

enum Ingredient: CaseIterable {
    case all
    case iceOrBase
    case main
    case topping
    
    var title: String {
        switch self {
        case .all:
            return "전체"
        case .iceOrBase:
            return "얼음ㆍ베이스"
        case .main:
            return "주 재료"
        case .topping:
            return "토핑"
        }
    }
}
// MARK: - 상점 Scene
final class StoreViewController: BaseViewController {
    
    private var viewModel: StoreViewModel!
    
    private let pointBar = PointBar()
    
    private let tagCollectionView = TTGTextTagCollectionView().then { tagView in
        tagView.numberOfLines = 1
        tagView.scrollDirection = .horizontal
        tagView.showsHorizontalScrollIndicator = false
        tagView.selectionLimit = 1
        
        let extraSpace = CGSize(width: 24.0, height: 20.0)
        let style = TTGTextTagStyle()
        style.backgroundColor = .p_ivory ?? .white
        style.cornerRadius = Constants.tagCornerRadius
        style.borderWidth = 1.0
        style.borderColor = .tagBorderColor ?? .black
        style.extraSpace = extraSpace
        
        let selectedStyle = TTGTextTagStyle()
        selectedStyle.backgroundColor = .p_brown ?? .brown
        selectedStyle.cornerRadius = Constants.tagCornerRadius
        selectedStyle.extraSpace = extraSpace
       
        
        Ingredient.allCases.forEach{
            ingredient in
            let font = UIFont.IM_Hyemin(.bold, size: 12.0)
            let tagContents = TTGTextTagStringContent(
                text: ingredient.title,
                textFont: font,
                textColor: .blackLabel
            )
            let selectedTagContents = TTGTextTagStringContent(
                text: ingredient.title,
                textFont: font,
                textColor: .p_ivory
            )
            let tag = TTGTextTag(
                content: tagContents,
                style: style,
                selectedContent: selectedTagContents,
                selectedStyle: selectedStyle
            )
            tagView.addTag(tag)
        }
    }
    static func create(with viewModel: StoreViewModel) -> StoreViewController {
        let vc = StoreViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
        [
            self.pointBar,
            self.tagCollectionView
        ].forEach {
            self.view.addSubview($0)
        }
        
        self.view.backgroundColor = .p_ivory
        self.navigationController?.isNavigationBarHidden = true
        
        self.pointBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(Constants.pointBarHeight)
        }
        
        self.tagCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.top.equalTo(self.pointBar.snp.bottom).offset(17.0)
        }
        
        self.tagCollectionView.delegate = self
    }
    
    override func bind() {
        
    }
}

extension StoreViewController: TTGTextTagCollectionViewDelegate {
}
