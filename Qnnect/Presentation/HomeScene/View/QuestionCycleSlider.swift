//
//  QuestionCycleSlider.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/22.
//

import UIKit
import Then

final class QuestionCycleSlider: UIView {
    private(set) var slider = CustomCycleSlider()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    private func configureUI() {
        self.addSubview(self.slider)
        
        self.slider.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
    }
    
    func update(with cycles: [QuestionCycle]) {
        let count = cycles.count
        self.slider.cycleCount = count
        let path = UIBezierPath()
        path.lineWidth = 1.0
        cycles.enumerated().forEach {
            let x = self.slider.frame.width * ( (CGFloat($0.offset)) / CGFloat(count - 1))
            if $0.offset != 0 , $0.offset != (count - 1) {
                path.move(to: CGPoint(x: x , y: 0))
                path.addLine(to: CGPoint(x: x, y: 11.0))
            }
            let label = UILabel()
            label.text = $0.element.title
            label.font = .IM_Hyemin(.bold, size: 14.0)
            label.textColor = .GRAY01
            
            self.addSubview(label)
            label.snp.makeConstraints { make in
                make.top.equalTo(self.slider.snp.bottom).offset(5.0)
                make.centerX.equalTo(x)
            }
        }
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = path.lineWidth
        shapeLayer.fillColor = UIColor.p_ivory?.cgColor
        shapeLayer.strokeColor = UIColor.p_ivory?.cgColor
        layer.addSublayer(shapeLayer)
    }
}

final class CustomCycleSlider: UISlider {
    var cycleCount: Int?
    override func trackRect(forBounds bound: CGRect) -> CGRect {
        //Here, set track frame
        return CGRect(origin: bound.origin, size: CGSize(width: bound.width, height: 11.0))
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
       
    }
}
