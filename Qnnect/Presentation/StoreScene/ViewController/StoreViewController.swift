//
//  StoreViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/16.
//

import UIKit
import SnapKit
import Then


// MARK: - 상점 Scene
final class StoreViewController: BaseViewController {
    
    private var viewModel: StoreViewModel!
    
    private let pointImageLeftBarItem = UIBarButtonItem().then {
        $0.image = Constants.pointImage
        $0.tintColor = .p_brown
    }
    static func create(with viewModel: StoreViewModel) -> StoreViewController {
        let vc = StoreViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        self.navigationItem.leftBarButtonItems = [self.pointImageLeftBarItem]
    }
    
    override func bind() {
        
    }
}
