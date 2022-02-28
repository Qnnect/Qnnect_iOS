//
//  GroupRoomViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/22.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class GroupRoomViewController: BaseViewController {
    
    private var viewModel: GroupRoomViewModel!
    
    static func create(with viewModel: GroupRoomViewModel) -> GroupRoomViewController{
        let vc = GroupRoomViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
    }
    
    override func bind() {
        
        let input = GroupRoomViewModel.Input(
            viewDidLoad: Observable.just(Void())
        )
        
        let output = self.viewModel.transform(from: input)
        
        output.roomInfo
            .drive()
            .disposed(by: self.disposeBag)
    }
}
