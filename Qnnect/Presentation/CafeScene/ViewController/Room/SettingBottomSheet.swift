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

enum SettingItemType: String,CaseIterable {
    case invite
    case cafeInfoModify
    case drinkModify
    case leaveCafe
    
    var title: String {
        switch self {
        case .invite:
            return "친구 초대하기"
        case .cafeInfoModify:
            return "카페 제목/주기/색상 수정하기"
        case .drinkModify:
            return "음료 수정하기"
        case .leaveCafe:
            return "카페 나가기"
        }
    }
}

final class SettingBottomSheet: BottomSheetViewController {
    
    private let menuTableView = UITableView().then {
        $0.register(SettingItemCell.self, forCellReuseIdentifier: SettingItemCell.identifier)
        $0.backgroundColor = .p_ivory
        $0.separatorStyle = .none
    }
    
    private let leaveCafeAlertView = LeaveCafeAlertView().then {
        $0.modalPresentationStyle = .overCurrentContext
    }
    
    private let notModifyDrinkAlertView = NotModifyDrinkAlertView().then {
        $0.modalPresentationStyle = .overCurrentContext
    }
    
    private var cafe: Cafe!
    private var viewModel: SettingBottomSheetViewModel!
    weak var coordinator: CafeCoordinator?
   
    
    static func create(
        with viewModel: SettingBottomSheetViewModel,
        _ cafe: Cafe,
        _ coordinator: CafeCoordinator
    ) -> SettingBottomSheet {
        let bottomSheet = SettingBottomSheet()
        bottomSheet.viewModel = viewModel
        bottomSheet.cafe = cafe
        bottomSheet.coordinator = coordinator
        return bottomSheet
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
        self.bottomSheetView.addSubview(self.menuTableView)
        
        self.topPadding = UIScreen.main.bounds.height * 0.55
        self.titleLabel.text = "설정"
        
        self.menuTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(25.0)
        }
    }
    
    override func bind() {
        
        Observable.just(
            SettingItemType.allCases
        ).bind(to: self.menuTableView.rx.items(cellIdentifier: SettingItemCell.identifier, cellType: SettingItemCell.self)) { index, element, cell in
            cell.update(with: element.title)
        }.disposed(by: self.disposeBag)
        
        let input = SettingBottomSheetViewModel.Input(
            didTapSettingItem: self.menuTableView.rx.modelSelected(SettingItemType.self)
                .asObservable(),
            cafe: Observable.just(cafe),
            didTapLeaveAlertOkButton: leaveCafeAlertView.okButton.rx.tap.asObservable()
        )
    
        let output = self.viewModel.transform(from: input)
        
        guard let coordinator = coordinator else { return }

        output.showInvitationScene
            .emit(onNext: coordinator.showInvitationScene)
            .disposed(by: self.disposeBag)
        
        output.showCafeModifyingScene
            .emit(onNext: coordinator.showCafeModifyingScene(_:))
            .disposed(by: self.disposeBag)
        
        output.leaveCafe
            .do {
                [weak self] _ in
                self?.leaveCafeAlertView.dismiss(animated: false, completion: nil)
            }
            .emit(onNext: coordinator.leaveCafe)
            .disposed(by: self.disposeBag)
        
        output.showLeaveCafeAlertView
            .emit(onNext: {
                [weak self] _ in
                guard let self = self else { return }
                self.present(self.leaveCafeAlertView, animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
        
        output.showNotModifyDrinkAlertView
            .emit(onNext: {
                [weak self] _ in
                guard let self = self else { return }
                self.present(self.notModifyDrinkAlertView, animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
        
        output.showSelectDrinkScene
            .emit(onNext: coordinator.showSelectDrinkBottomSheet(_:))
            .disposed(by: self.disposeBag)
    }
}
