//
//  ReportBottomSheet.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/23.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class ReportBottomSheet: BottomSheetViewController {
    
    private let reportButton = MoreMenuItem(title: "신고 하기")
    private let blockButton = MoreMenuItem(title: "차단 하기")
    
    private let buttonStackView = UIStackView().then {
        $0.spacing = 30.0
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .leading
    }
    
    private let deleteAlertView = DeleteAlertView().then {
        $0.modalPresentationStyle = .overCurrentContext
    }
    
  
    private var viewModel: ReportBottomSheetViewModel!
    weak var coordinator: ReportCoordinator?
    
    static func create(
        with viewModel: ReportBottomSheetViewModel,
        _ coordinator: ReportCoordinator
    ) -> ReportBottomSheet {
        let view = ReportBottomSheet()
        view.viewModel = viewModel
        view.coordinator = coordinator
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        
        topPadding = UIScreen.main.bounds.height * 0.75
        
        dismissButton.isHidden = true
        
        
        [
            reportButton,
            blockButton
        ].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        
        bottomSheetView.addSubview(buttonStackView)
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.top.equalToSuperview().inset(44.0)
        }
    }
    
    override func bind() {
        super.bind()
        
        let input = ReportBottomSheetViewModel.Input(
            didTapReportButton: reportButton.rx.tap.asObservable(),
            didTapblockButton: blockButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(from: input)
        
        guard let coordinator = coordinator else { return}

        
    }
}
