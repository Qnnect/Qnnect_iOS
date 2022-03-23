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
import MessageUI

protocol ReportBottomSheetDelegate: AnyObject {
    func sendMail(reportUser: User)
}


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
    private var user: User!
    private weak var delegate: MFMailComposeViewControllerDelegate?
    
    static func create(
        with viewModel: ReportBottomSheetViewModel,
        _ coordinator: ReportCoordinator,
        _ user: User,
        _ delegate: MFMailComposeViewControllerDelegate
    ) -> ReportBottomSheet {
        let view = ReportBottomSheet()
        view.viewModel = viewModel
        view.coordinator = coordinator
        view.user = user
        view.delegate = delegate
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
            didTapblockButton: blockButton.rx.tap.asObservable(),
            reportUser: Observable.just(user)
        )
        
        let output = viewModel.transform(from: input)
        
        output.report
            .emit(onNext: sendEmail)
            .disposed(by: self.disposeBag)
        
        guard let coordinator = coordinator else { return}
        
        
    }
}

private extension ReportBottomSheet {
    func sendEmail(_ user: User) {
        // 이메일 사용가능한지 체크하는 if문
        if MFMailComposeViewController.canSendMail() {
            if let presentingVC = presentingViewController  {
                let compseVC = MFMailComposeViewController()
                compseVC.mailComposeDelegate = delegate
                compseVC.setToRecipients([APP.reportEmail])
                compseVC.setSubject("유저 신고하기")
                compseVC.setMessageBody("신고하려는 유저 이름 : \(user.name)\n신고 내용 : ",
                                        isHTML: false)
                dismiss(animated: false, completion: {
                    presentingVC.present(compseVC, animated: true, completion: nil)
                })
            }
            
        }
        else {
            self.showSendMailErrorAlert()
        }
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "메일을 전송 실패", message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) {
            (action) in
            print("확인")
        }
        sendMailErrorAlert.addAction(confirmAction)
        if let presentingVC = presentingViewController {
            dismiss(animated: false, completion: {
                presentingVC.present(sendMailErrorAlert, animated: true, completion: nil)
            })
        }
    }
}
