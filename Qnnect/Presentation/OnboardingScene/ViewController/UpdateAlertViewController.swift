//
//  UpdateAlertViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/04/03.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class UpdateAlertViewController: BaseViewController {
    
    private let titleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .blackLabel
        $0.numberOfLines = 2
        let paragraphStyle = Constants.paragraphStyle
        paragraphStyle.alignment = .center
        $0.attributedText = NSMutableAttributedString(
            string: "큐넥트의 새로운 버전이 나왔습니다\n업데이트 하시겠어요?",
            attributes: [NSAttributedString.Key.paragraphStyle: Constants.paragraphStyle]
        )
    }
    
    private let secondaryLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 12.0)
        $0.textColor = .GRAY03
        $0.text = "업데이트를 진행해야 이용할 수 있어요"
    }
    
    
    private let appStoreButton = UIButton().then {
        $0.setTitle("앱스토어로 가기", for: .normal)
        $0.setTitleColor(.WHITE_FFFFFF, for: .normal)
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        $0.backgroundColor = .p_brown
        $0.layer.cornerRadius = 10.0
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.BLACK_121212?.cgColor
    }
    

    private let alertView = UIView().then {
        $0.backgroundColor = .p_ivory
        $0.layer.cornerRadius = 16.0
    }
    
    private var viewModel: UpdateAlertViewModel!
    weak var coordinator: SplashCoordinator?
    
    static func create(
        with viewModel: UpdateAlertViewModel,
        _ coordinator: SplashCoordinator
    ) -> UpdateAlertViewController {
        let vc = UpdateAlertViewController()
        vc.viewModel = viewModel
        vc.coordinator = coordinator
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
       
        
        [
            titleLabel,
            secondaryLabel,
            appStoreButton
        ].forEach {
            self.alertView.addSubview($0)
        }
        
        self.view.addSubview(self.alertView)
        self.view.backgroundColor = .black.withAlphaComponent(0.5)
        
        self.alertView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(28.0)
            make.height.equalTo(200.0)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(25.0)
            make.centerX.equalToSuperview()
        }
    
        self.secondaryLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(6.0)
            make.centerX.equalToSuperview()
        }
        
        appStoreButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.bottom.equalToSuperview().inset(25.0)
            make.height.equalTo(50.0)
        }
    }
    
    override func bind() {
        
        let input = UpdateAlertViewModel.Input(
            didTapAppStoreButton: appStoreButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(from: input)
        
        guard let coordinator = coordinator else { return }

        output.showAppStore
            .emit(onNext: coordinator.dismiss)
            .disposed(by: self.disposeBag)
    }
}
