//
//  BaseViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/06.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .p_ivory
        self.configureUI()
        self.bind()
    }
    
    func configureUI() {
        
    }
    
    func bind() {
        
    }
 
}
