//
//  CustomTagCollectionview.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/17.
//

import UIKit
import TTGTags

final class CustomTagCollectionView: TTGTextTagCollectionView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureUI() {
        self.numberOfLines = 1
        self.scrollDirection = .horizontal
        self.showsHorizontalScrollIndicator = false
        self.selectionLimit = 2
        
        
    }
    
    func update(with titles: [String]) {
        let extraSpace = Constants.tagExtraSpace
        let style = TTGTextTagStyle()
        style.backgroundColor = .p_ivory ?? .white
        style.cornerRadius = Constants.tagCornerRadius
        style.borderWidth = Constants.tagBorderWidth
        style.borderColor = .tagBorderColor ?? .black
        style.extraSpace = extraSpace
        
        let selectedStyle = TTGTextTagStyle()
        selectedStyle.backgroundColor = .p_brown ?? .brown
        selectedStyle.cornerRadius = Constants.tagCornerRadius
        selectedStyle.extraSpace = extraSpace
       
        self.addWholeTag(style: style, selectedStyle: selectedStyle)
        
        titles.forEach{
            title in
            let font = UIFont.IM_Hyemin(.bold, size: 12.0)
            let tagContents = TTGTextTagStringContent(
                text: title,
                textFont: font,
                textColor: .blackLabel
            )
            let selectedTagContents = TTGTextTagStringContent(
                text: title,
                textFont: font,
                textColor: .p_ivory
            )
            let tag = TTGTextTag(
                content: tagContents,
                style: style,
                selectedContent: selectedTagContents,
                selectedStyle: selectedStyle
            )
            self.addTag(tag)
        }
    }
}
