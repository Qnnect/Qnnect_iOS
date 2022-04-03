//
//  SetNotificationViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/04/03.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class SetNotificationViewController: BaseViewController {
    
    private let navigationTitleLabel = NavigationTitleLabel(title: "알림 설정")
    
    private let mainLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.text = "알림"
    }
    
    private let toggleButton = UISwitch().then {
        $0.onTintColor = .p_brown
    }
    
    private var viewModel: SetNotificationViewModel!
    weak var coordinator: MyPageCoordinator?
    
    static func create(
        with viewModel: SetNotificationViewModel,
        _ coordinator: MyPageCoordinator
    ) -> SetNotificationViewController {
        let vc = SetNotificationViewController()
        vc.viewModel = viewModel
        vc.coordinator = coordinator
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        
        [
            mainLabel,
            toggleButton
        ].forEach {
            view.addSubview($0)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(view.safeAreaLayoutGuide).inset(20.0)
        }
        
        toggleButton.snp.makeConstraints { make in
            make.trailing.top.equalTo(view.safeAreaLayoutGuide).inset(20.0)
        }
        
        navigationItem.titleView = navigationTitleLabel
    }
    
    override func bind() {
        super.bind()
        
        let input = SetNotificationViewModel.Input(
            viewDidLoad: Observable.just(()),
            toggle: toggleButton.rx.isOn.asObservable().skip(1)
        )
        
        let output = viewModel.transform(from: input)
        
        output.isOn
            .drive(onNext: {
                [weak self] isOn in
                self?.toggleButton.isOn = isOn
            })
            .disposed(by: self.disposeBag)
        
        output.setEnableNotification
            .emit()
            .disposed(by: self.disposeBag)
    }
}
