//
//  SplashViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import UIKit
import SnapKit
import Then
import Photos
import RxSwift

final class SplashViewController: BaseViewController {
    
    private let testLabel = UILabel().then {
        $0.text = "Splash"
        $0.font = .BM_JUA(size: 28.0)
        $0.textColor = .GRAY01
    }
    
    private var viewModel: SplashViewModel!
    static func create(with viewModel: SplashViewModel) -> SplashViewController {
        let vc = SplashViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        self.view.addSubview(testLabel)
        
        self.testLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.7)
        }
    }
    
    override func bind() {
        
        let didEndSplash = PublishSubject<Void>()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            didEndSplash.onNext(())
        }
        let input = SplashViewModel.Input(didEndSplash: didEndSplash.asObservable())
        
        let output = self.viewModel.transform(from: input)
        
        output.showLogin
            .emit()
            .disposed(by: self.disposeBag)
        
        output.showMain
            .emit()
            .disposed(by: self.disposeBag)
        
        output.showOnboarding
            .emit()
            .disposed(by: self.disposeBag)
    }
}
