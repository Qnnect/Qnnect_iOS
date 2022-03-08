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
    
    private let mainImageView = UIImageView().then {
        $0.image = Constants.splashImage
        $0.contentMode = .scaleAspectFit
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
        self.view.addSubview(self.mainImageView)
        
        self.mainImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.7)
        }
    }
    
    override func bind() {
        
        let didEndSplash = PublishSubject<Void>()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            didEndSplash.onNext(())
            print("abc")
        }
        
        let input = SplashViewModel.Input(didEndSplash: didEndSplash.asObservable())
        
        let output = self.viewModel.transform(from: input)
        
        output.showLogin
            .emit(onNext: {
                print("show Login")
            })
            .disposed(by: self.disposeBag)
        
        output.showMain
            .emit(onNext: {
                print("show Main")
            })
            .disposed(by: self.disposeBag)
        
        output.showOnboarding
            .emit(onNext: {
                print("show Onboarding")
            })
            .disposed(by: self.disposeBag)
    }
}
