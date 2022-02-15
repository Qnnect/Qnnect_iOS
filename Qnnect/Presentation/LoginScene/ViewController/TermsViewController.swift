//
//  TermsViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/14.
//

import UIKit
import SnapKit
import Then

final class TermsViewController: BaseViewController {
    
    private let startButton = UIButton().then {
        $0.setTitle("시작하기", for: .normal)
        $0.backgroundColor = .p_brown
    }
    
    private var viewModel: TermsViewModel!
    
    static func create(with viewModel: TermsViewModel) -> TermsViewController {
        let vc = TermsViewController()
        vc.viewModel = viewModel
        return vc 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
        [
            self.startButton
        ].forEach {
            self.view.addSubview($0)
        }
        
        self.startButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100.0)
        }
    }
    
    override func bind() {
        let input = TermsViewModel.Input(
            didTapStartButton: self.startButton.rx.tap
                .asObservable()
                .mapToVoid()
        )
        
        let output = self.viewModel.transform(from: input)
        output.start
            .emit()
            .disposed(by: self.disposeBag)
    }
}
