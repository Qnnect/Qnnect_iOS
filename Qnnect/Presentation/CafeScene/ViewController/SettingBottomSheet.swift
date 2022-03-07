//
//  SettingBottomSheet.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/07.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class SettingBottomSheet: BottomSheetViewController {
    
    private let menuTableView = UITableView().then {
        $0.register(SettingItemCell.self, forCellReuseIdentifier: SettingItemCell.identifier)
        $0.backgroundColor = .p_ivory
    }
    
    static func create() -> SettingBottomSheet {
        let bottomSheet = SettingBottomSheet()
        return bottomSheet
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
        self.bottomSheetView.addSubview(self.menuTableView)
        
        self.topPadding = 446.0
        self.titleLabel.text = "설정"
        
        self.menuTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(25.0)
        }
    }
    
    override func bind() {
        
        Observable.just(
            [
                "친구 초대하기",
                "카페 제목/주기/색상 수정하기",
                "음료 수정하기",
                "다어이리 삭제"
            ]
        ).bind(to: self.menuTableView.rx.items(cellIdentifier: SettingItemCell.identifier, cellType: SettingItemCell.self)) { index, element, cell in
            cell.update(with: element)
        }.disposed(by: self.disposeBag)
    }
}
