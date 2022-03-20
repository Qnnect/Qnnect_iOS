//
//  UITableView+.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/20.
//

import UIKit
import SnapKit

extension UITableView {
    func setEmptyView(message: String) {
        let messageLabel = UILabel()
        messageLabel.font = .IM_Hyemin(.bold, size: 16.0)
        messageLabel.textColor = .BLACK_121212
        messageLabel.textAlignment = .center
        messageLabel.text = message
        messageLabel.sizeToFit()
        
        let imageView = UIImageView()
        imageView.image = Constants.listEmptyImage
        imageView.contentMode = .scaleAspectFit
        
        let backgroudView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        backgroudView.addSubview(messageLabel)
        backgroudView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(113.0)
            make.trailing.equalToSuperview().inset(97.0)
            make.top.equalToSuperview().inset(219.0)
            make.bottom.equalTo(messageLabel.snp.top).offset(-25.0)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(198.0)
            make.leading.trailing.equalToSuperview().inset(16.0)
        }
        messageLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        self.backgroundView = backgroudView

    }
    
    func reset() {
        self.backgroundView = nil
    }
}
