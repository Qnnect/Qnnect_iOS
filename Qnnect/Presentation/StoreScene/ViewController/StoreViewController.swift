//
//  StoreViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/16.
//

import UIKit
import SnapKit
import Then

final class StoreViewController: BaseViewController {
    
    private var viewModel: StoreViewModel!
    static func create(with viewModel: StoreViewModel) -> StoreViewController {
        let vc = StoreViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        
    }
    
    override func configureUI() {
        
    }
    
    override func bind() {
        
    }
}
