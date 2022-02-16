//
//  BookMarkViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/16.
//

import UIKit
import SnapKit
import Then

final class BookmarkViewController: BaseViewController {
    
    private var viewModel: BookmarkViewModel!
    
    static func create(with viewModel: BookmarkViewModel) -> BookmarkViewController{
        let vc = BookmarkViewController()
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
