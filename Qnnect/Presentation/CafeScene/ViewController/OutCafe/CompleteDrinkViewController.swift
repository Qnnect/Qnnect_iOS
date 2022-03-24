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
        $0.textAlignment = .center
    }
    
    private let celebrationImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = Constants.completionCelebrateImage
    }
    
    private let drinkShadowImageView = UIImageView().then {
        $0.image = Constants.drinkShadow
        $0.contentMode = .scaleToFill
    }
    
    private var curStep: DrinkStep!
    private var userDrink: DrinkType!
    weak var coordinator: OurCafeCoordinator?
    
    static func create(with curStep: DrinkStep, _ userDrink: DrinkType, _ coordinator: OurCafeCoordinator) -> CompleteDrinkViewController {
        let vc = CompleteDrinkViewController()
        vc.curStep = curStep
        vc.userDrink = userDrink
        vc.coordinator = coordinator
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        
        [
            drinkShadowImageView,
            twinkleImageView,
            drinkImageView,
            mainLabel,
            secondaryLabel,
            celebrationImageView
        ].forEach {
            view.addSubview($0)
        }
        
        view.backgroundColor = .SECONDARY01
    
        celebrationImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(120.0)
            //make.top.equalTo(secondaryLabel.snp.bottom).offset(57.0)
            make.bottom.equalToSuperview().inset(100.0)
        }
       
        secondaryLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.bottom.equalTo(celebrationImageView.snp.top).offset(-57.0)
           // make.top.equalTo(mainLabel.snp.bottom).offset(3.0)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(36.0)
            make.bottom.equalTo(secondaryLabel.snp.top).offset(-4.0)
            //make.top.equalTo(drinkImageView.snp.bottom).inset(20.0)
        }
        mainLabel.text = "\(userDrink.rawValue) 완성!"
        
        drinkImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(95.5)
            make.bottom.equalTo(mainLabel.snp.top).offset(-20.0)
            make.top.equalTo(twinkleImageView.snp.bottom).offset(20.0)
        }
        
        drinkShadowImageView.snp.makeConstraints { make in
            make.bottom.equalTo(drinkImageView).offset(5.0)
            make.leading.equalTo(drinkImageView).offset(43.0)
            make.trailing.equalTo(drinkImageView).offset(-41.0)
            make.height.equalToSuperview().multipliedBy(0.03694)
        }
        
        drinkImageView.image = userDrink.getDrinkStepImage(.completed) //twinkle 이미지
        drinkImageView.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        
        twinkleImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(102.0)
            make.top.equalToSuperview().inset(97.0)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        coordinator?.disMissCompleteDrinkScene()
    }
    
    override func bind() {
        super.bind()
    }
}


import SwiftUI
struct ViewController_Priviews: PreviewProvider {
    static var previews: some View {
        Contatiner().edgesIgnoringSafeArea(.all)
    }
    struct Contatiner: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            let vc = CompleteDrinkViewController.create(
                with: .completed,
                .chocoLatte,
                DefaultOurCafeCoordinator(navigationController: UINavigationController())
            ) //보고 싶은 뷰컨 객체
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        typealias UIViewControllerType =  UIViewController
    }
}

