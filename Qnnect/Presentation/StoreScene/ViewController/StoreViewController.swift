//
//  StoreViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/16.
//

import UIKit
import SnapKit
import Then
import KakaoSDKCommon


// MARK: - 상점 Scene
final class StoreViewController: BaseViewController {
    
    private var viewModel: StoreViewModel!
    
    private let pointBar = PointBar()
    
    static func create(with viewModel: StoreViewModel) -> StoreViewController {
        let vc = StoreViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
        [
            self.pointBar
        ].forEach {
            self.view.addSubview($0)
        }
        
        self.view.backgroundColor = .p_ivory
        self.navigationController?.isNavigationBarHidden = true
        
        self.pointBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(50.0)
        }
    }
    
    override func bind() {
        
    }
}
