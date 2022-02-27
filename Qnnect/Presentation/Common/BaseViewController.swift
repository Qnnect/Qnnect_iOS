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
        
        let barAppearance = self.navigationController?.navigationBar.standardAppearance
        barAppearance?.shadowColor = UIColor.black.withAlphaComponent(0.08)
        barAppearance?.backgroundColor = .p_ivory
        self.navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
        self.navigationController?.navigationBar.compactAppearance = barAppearance
        
        self.configureUI()
        self.bind()
    }
    
    func configureUI() {
        
    }
    
    func bind() {
        
    }
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
    }
}
