//
//  TTGTextTagCollectionView+.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/17.
//

import Foundation
import TTGTags
import RxSwift
import RxCocoa

class TTGTextTagProxy: DelegateProxy<TTGTextTagCollectionView, TTGTextTagCollectionViewDelegate>, DelegateProxyType, TTGTextTagCollectionViewDelegate {
    static func registerKnownImplementations() {
        self.register { (controller) -> TTGTextTagProxy in
            TTGTextTagProxy(parentObject: controller, delegateProxy: self)
        }
    }

    static func currentDelegate(for object: TTGTextTagCollectionView) -> TTGTextTagCollectionViewDelegate? {
        return object.delegate
    }

    static func setCurrentDelegate(_ delegate: TTGTextTagCollectionViewDelegate?, to object: TTGTextTagCollectionView) {
        object.delegate = delegate
    }
}
extension Reactive where Base: TTGTextTagCollectionView {
    var delegate : DelegateProxy<TTGTextTagCollectionView, TTGTextTagCollectionViewDelegate> {
        return TTGTextTagProxy.proxy(for: self.base)
    }

    var tappedTagTitle: Observable<String> {
        return delegate.methodInvoked(#selector(TTGTextTagCollectionViewDelegate.textTagCollectionView(_:didTap:at:)))
            .map { parameter -> String in
                let tag = parameter[1] as? TTGTextTag ?? TTGTextTag()
                return tag.content.getAttributedString().string 
            }
    }
}
