//
//  MyPageAlertViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/23.
//

import UIKit
import SnapKit
import Then
import RxSwift

enum LeaveType {
    case logout
    case withdrawl
    
    var message: String {
        switch self {
        case .logout:
            return "로그아웃 되었습니다."
        case .withdrawl:
            return "회원탈퇴 되었습니다."
        }
    }
}

final class MyPageAlertViewController: BaseViewController {
    
    private let titleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .blackLabel
    }

    private let cancleButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.WHITE_FFFFFF, for: .normal)
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        $0.backgroundColor = .GRAY04
        $0.layer.cornerRadius = 10.0
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.GRAY03?.cgColor
    }
    
    private(set) var okButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.WHITE_FFFFFF, for: .normal)
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        $0.backgroundColor = .p_brown
        $0.layer.cornerRadius = 10.0
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.BLACK_121212?.cgColor
    }
    
    private let buttonStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        $0.spacing = 12.0
    }
    
    private let alertView = UIView().then {
        $0.backgroundColor = .p_ivory
        $0.layer.cornerRadius = 16.0
    }
    
    private var viewModel: MyPageAlertViewModel!
    weak var coordinator: MyPageCoordinator?
    private var myPageItem: MyPageItem!
    
    static func create(
        with viewModel: MyPageAlertViewModel,
        _ coordinator: MyPageCoordinator,
        _ myPageItem: MyPageItem
    ) -> MyPageAlertViewController {
        let view = MyPageAlertViewController()
        view.viewModel = viewModel
        view.coordinator = coordinator
        view.myPageItem = myPageItem
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
        [
            self.cancleButton,
            self.okButton
        ].forEach {
            self.buttonStackView.addArrangedSubview($0)
        }
        
        [
            self.titleLabel,
            self.buttonStackView
        ].forEach {
            self.alertView.addSubview($0)
        }
        
        self.view.addSubview(self.alertView)
        self.view.backgroundColor = .black.withAlphaComponent(0.5)
        
        self.alertView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(28.0)
            make.height.equalTo(180.0)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(44.0)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.text = myPageItem == .logout ? "로그아웃 하시겠어요?" : "회원탈퇴 하시겠어요?"
    
        self.buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.bottom.equalToSuperview().inset(25.0)
            make.height.equalTo(50.0)
        }
    }
    
    override func bind() {
        super.bind()
        
        let input = MyPageAlertViewModel.Input(
            myPageItem: Observable.just(myPageItem),
            didTapOkButton: okButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(from: input)
        
        cancleButton.rx.tap
            .subscribe(onNext: {
                [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
        
        guard let coordinator = coordinator else { return }

        output.logout
            .map { LeaveType.logout }
            .emit(onNext: coordinator.showLoginScene)
            .disposed(by: self.disposeBag)
        
        output.withdrawl
            .map { LeaveType.withdrawl }
            .emit(onNext: coordinator.showLoginScene)
            .disposed(by: self.disposeBag)
        
    }
}
