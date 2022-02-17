//
//  TTGTextTagCollectionView.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/17.
//

import Foundation
import TTGTags

extension TTGTextTagCollectionView {
    func addWholeTag(style: TTGTextTagStyle, selectedStyle: TTGTextTagStyle) {
        let font = UIFont.IM_Hyemin(.bold, size: 12.0)
        
        let tagContents = TTGTextTagStringContent(
            text: "전체",
            textFont: font,
            textColor: .blackLabel
        )
        let selectedTagContents = TTGTextTagStringContent(
            text: "전체",
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
