//
//  MyPageViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/16.
//

import UIKit
import SnapKit
import Then

final class MyPageViewController: BaseViewController {
    
    private var viewModel: MyPageViewModel!
    
    static func create(with viewModel: MyPageViewModel) -> MyPageViewController {
        let vc = MyPageViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
    }
    
    override func bind() {
        
    }
}
