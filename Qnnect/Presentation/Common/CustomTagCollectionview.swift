//
//  CustomTagCollectionview.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/17.
//

import UIKit
import TTGTags

final class CustomTagCollectionView: TTGTextTagCollectionView {
    
    private let style = TTGTextTagStyle().then {
        $0.backgroundColor = .p_ivory ?? .white
        $0.cornerRadius = Constants.tagCornerRadius
        $0.borderWidth = Constants.tagBorderWidth
        $0.borderColor = .tagBorderColor ?? .black
        $0.extraSpace = Constants.tagExtraSpace
    }
    
    private let selectedStyle = TTGTextTagStyle().then {
        $0.backgroundColor = .p_brown ?? .brown
        $0.cornerRadius = Constants.tagCornerRadius
        $0.extraSpace = Constants.tagExtraSpace
    }
    
    private let tagFont: UIFont = .IM_Hyemin(.bold, size: 14.0)
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
        self.delegate = self
    }
    
    func update(with titles: [String]) {
        titles.forEach{
            title in
            let tagContents = TTGTextTagStringContent(
                text: title,
                textFont: tagFont,
                textColor: .GRAY01
            )
            let selectedTagContents = TTGTextTagStringContent(
                text: title,
                textFont: tagFont,
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
    
    func addWholeTag() {
        let tagContents = TTGTextTagStringContent(
            text: "전체",
            textFont: tagFont,
            textColor: .blackLabel
        )
        let selectedTagContents = TTGTextTagStringContent(
            text: "전체",
            textFont: tagFont,
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

extension CustomTagCollectionView: TTGTextTagCollectionViewDelegate {
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTap tag: TTGTextTag!, at index: UInt) {
        let tags = textTagCollectionView?.allTags() ?? []
        tags.enumerated().forEach {
            if $0.element != tag, $0.element.selected {
                textTagCollectionView?.updateTag(at: UInt($0.offset), selected: false)
            }
        }
    }
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, canTap tag: TTGTextTag!, at index: UInt) -> Bool {
        return !tag.selected
    }
}
