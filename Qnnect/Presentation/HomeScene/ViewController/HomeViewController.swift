//
//  HomeViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/14.
//

import UIKit
import SnapKit
import Then

final class HomeViewController: BaseViewController {
    
    private var viewModel: HomeViewModel!
    
    private let pointBar = PointBar()
    
//    private let mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
//        $0.back
//    }
    
    static func create(with viewModel: HomeViewModel) -> HomeViewController {
        let vc = HomeViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        self.view.backgroundColor = .p_ivory
    }
    
    override func bind() {
        
    }
}
