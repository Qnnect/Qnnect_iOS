//
//  IndicatorView.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/17.
//

import NVActivityIndicatorView
import UIKit


class LoadingIndicator {
    static func showLoading() {
        DispatchQueue.main.async {
            // 최상단에 있는 window 객체 획득
            guard let window = UIApplication.shared.windows.last else { return }
            
            let loadingIndicatorView: NVActivityIndicatorView
            if let existedView = window.subviews.first(where: { $0 is NVActivityIndicatorView } ) as? NVActivityIndicatorView {
                loadingIndicatorView = existedView
            } else {
                loadingIndicatorView = NVActivityIndicatorView(
                    frame: .init(x: UIScreen.main.bounds.width / 2.0,
                                 y: UIScreen.main.bounds.width / 2.0, width: 50.0, height: 50.0),
                    type: .lineSpinFadeLoader,
                    color: .black
                )
                
                window.addSubview(loadingIndicatorView)
            }

            loadingIndicatorView.startAnimating()
        }
    }

    static func hideLoading() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else { return }
            window.subviews.filter({ $0 is NVActivityIndicatorView }).forEach { $0.removeFromSuperview() }
        }
    }
}
