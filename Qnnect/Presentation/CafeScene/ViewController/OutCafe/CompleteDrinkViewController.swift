//
//  CompleteDrinkViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/21.
//

import Foundation
import SnapKit
import Then
import UIKit

final class CompleteDrinkViewController: BaseViewController {
    
    private let twinkleImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = Constants.completionTwinkle
    }
    
    private let drinkImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    /// 음료 이름 + 완성!
    private let mainLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 18.0)
        $0.textColor = .black
        $0.text = "음료이름 완성!"
        $0.textAlignment = .center
    }

    private let secondaryLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.textColor = .GRAY02
        $0.text = "마이페이지에서 음료 스탬프를 확인해보세요!"
    }
    
    private let celebrationImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = Constants.completionCelebrateImage
    }
    
    private var curStep: DrinkStep!
    private var drinkName: String!
    weak var coordinator: OurCafeCoordinator?
    
    static func create(with curStep: DrinkStep, _ drinkName: String, _ coordinator: OurCafeCoordinator) -> CompleteDrinkViewController {
        let vc = CompleteDrinkViewController()
        vc.curStep = curStep
        vc.drinkName = drinkName
        vc.coordinator = coordinator
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        
        [
            twinkleImageView,
            drinkImageView,
            mainLabel,
            secondaryLabel,
            celebrationImageView
        ].forEach {
            view.addSubview($0)
        }
        
        view.backgroundColor = .SECONDARY01
    
        twinkleImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(102.0)
            make.top.equalToSuperview().inset(130.0)
        }
        
        drinkImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(100.0)
            make.top.equalTo(twinkleImageView.snp.bottom).offset(20.0)
        }
        drinkImageView.image = curStep.getDrinkImage(drinkName)
        
        mainLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(36.0)
            make.top.equalToSuperview().inset(20.0)
        }
        mainLabel.text = "\(drinkName) 완성!"
        
        secondaryLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.top.equalTo(mainLabel.snp.bottom).offset(3.0)
        }
        
        celebrationImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(secondaryLabel.snp.bottom).offset(57.0)
            make.bottom.equalToSuperview().inset(100.0)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.dismiss(animated: true, completion: nil)
    }
    
    override func bind() {
        super.bind()
    }
}
