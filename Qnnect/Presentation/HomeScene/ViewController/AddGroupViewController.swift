//
//  AddGroupViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/21.
//

import UIKit
import SnapKit
import Then
import RxSwift
import TTGTags

enum GroupType: CaseIterable {
    case friend
    case family
    case couple
    
    var title: String {
        switch self {
        case .friend:
            return "친구"
        case .family:
            return "가족"
        case .couple:
            return "커플"
        }
    }
}

enum DiaryColorType: CaseIterable{
    case orange
    case pink
    case yellow
    case iceblue
    case brown
    
    var defaultImage: UIImage? {
        switch self {
        case .orange:
            return UIImage(named: "diary_color_orange")
        case  .pink:
            return UIImage(named: "diary_color_pink")
        case  .yellow:
            return UIImage(named: "diary_color_yellow")
        case  .iceblue:
            return UIImage(named: "diary_color_iceblue")
        case  .brown:
            return UIImage(named: "diary_color_brown")
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .orange:
            return UIImage(named: "diary_color_orange_checked")
        case .pink:
            return UIImage(named: "diary_color_pink_checked")
        case .yellow:
            return UIImage(named: "diary_color_yellow_checked")
        case .iceblue:
            return UIImage(named: "diary_color_iceblue_checked")
        case .brown:
            return UIImage(named: "diary_color_brown_checked")
        }
    }
}

enum QuestionCycle: CaseIterable {
    case every
    case three
    case five
    case seven
    
    var title: String {
        switch self {
        case .every:
            return "매일"
        case .three:
            return "3일"
        case .five:
            return "5일"
        case .seven:
            return "7일"
        }
    }
}

final class AddGroupViewController: BaseViewController {
    
    // 바텀 시트 뷰
    private let bottomSheetView = UIView().then {
        $0.backgroundColor = .p_ivory
        $0.layer.cornerRadius = 24.0
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
    
    private let dimmendView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.5)
    }
    private let dismissButton = UIButton().then {
        $0.setImage(Constants.xmarkImage, for: .normal)
        $0.addTarget(self, action: #selector(didTapDismissButton), for: .touchUpInside)
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .GRAY01
        $0.text = "그룹추가"
    }
    
    private let inputTitleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .GRAY01
        $0.text = "제목을 입력해주세요"
    }
    
    private let inputTitleTextField = UITextField().then {
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.textColor = .GRAY01
        $0.placeholder = "10자 이내"
    }
    
    private let groupTypeLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .GRAY01
        $0.text = "누구와 함께 하나요?"
    }
    
    private let groupTypeTagCollectionView = CustomTagCollectionView().then {
        $0.update(with: GroupType.allCases.map{$0.title})
    }
    
    private let diaryColorLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .GRAY01
        $0.text = "다이어리 색상을 골라주세요"
    }
    
    private let diaryColorCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    ).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: 39.0, height: 38.0)
        $0.collectionViewLayout = layout
        $0.register(
            DiaryColorCell.self,
            forCellWithReuseIdentifier: DiaryColorCell.identifier
        )
        $0.backgroundColor = .p_ivory
    }
    
    private let questionCycleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .GRAY01
        $0.text = "질문 주기를 선택해주세요"
    }
    
    private let questionCycleSlider = QuestionCycleSlider().then {
        $0.slider.maximumTrackTintColor = .GRAY05
        $0.slider.minimumTrackTintColor = .p_brown
    }
    
    private let nextButton = UIButton().then {
        $0.isEnabled = false
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        $0.setTitleColor(.WHITE_FFFFFF, for: .normal)
        $0.backgroundColor = .GRAY04
        $0.layer.cornerRadius = 10.0
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupGestureRecognizer()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.showBottomSheet()
        self.drawUnderLine()
        self.questionCycleSlider.update(with: QuestionCycle.allCases)
    }
    
    override func configureUI() {
        
        [
            self.dismissButton,
            self.titleLabel,
            self.inputTitleLabel,
            self.inputTitleTextField,
            self.groupTypeLabel,
            self.groupTypeTagCollectionView,
            self.diaryColorLabel,
            self.diaryColorCollectionView,
            self.questionCycleLabel,
            self.questionCycleSlider,
            self.nextButton
        ].forEach {
            self.bottomSheetView.addSubview($0)
        }
        
        [
            self.dimmendView,
            self.bottomSheetView
        ].forEach {
            self.view.addSubview($0)
        }
        
        self.view.backgroundColor = .black.withAlphaComponent(0.5)
        
        self.dimmendView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.bottomSheetView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
        
        self.dismissButton.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(8.0)
            make.width.height.equalTo(48.0)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.dismissButton)
        }
        
        self.inputTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.dismissButton.snp.bottom).offset(22.0)
            make.leading.trailing.equalToSuperview().inset(20.0)
        }
        
        self.inputTitleTextField.snp.makeConstraints { make in
            make.top.equalTo(self.inputTitleLabel.snp.bottom).offset(16.0)
            make.leading.trailing.equalTo(self.inputTitleLabel)
        }
        
        self.groupTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.inputTitleTextField.snp.bottom).offset(36.0)
            make.leading.trailing.equalTo(inputTitleLabel)
        }
        
        self.groupTypeTagCollectionView.snp.makeConstraints { make in
            make.height.equalTo(40.0)
            make.top.equalTo(self.groupTypeLabel.snp.bottom).offset(16.0)
            make.leading.trailing.equalTo(self.inputTitleLabel)
        }
        
        self.diaryColorLabel.snp.makeConstraints { make in
            make.top.equalTo(self.groupTypeTagCollectionView.snp.bottom).offset(28.0)
            make.leading.trailing.equalTo(self.inputTitleLabel)
        }
        
        self.diaryColorCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.diaryColorLabel.snp.bottom).offset(16.0)
            make.leading.trailing.equalTo(self.inputTitleLabel)
            make.height.equalTo(50.0)
        }
        
        self.questionCycleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.diaryColorCollectionView.snp.bottom).offset(28.0)
            make.leading.trailing.equalTo(self.inputTitleLabel)
        }
        
        self.questionCycleSlider.snp.makeConstraints { make in
            make.top.equalTo(self.questionCycleLabel.snp.bottom).offset(16.0)
            make.leading.trailing.equalTo(self.inputTitleLabel)
            make.height.equalTo(55.0)
        }
        
        self.nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.inputTitleLabel)
            make.height.equalTo(Constants.bottomButtonHeight)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(60.0)
            make.top.greaterThanOrEqualTo(self.questionCycleSlider.snp.bottom).offset(16.0)
        }
    }
    
    override func bind() {
        Observable.just(DiaryColorType.allCases)
            .bind(to: self.diaryColorCollectionView.rx.items(cellIdentifier: DiaryColorCell.identifier, cellType: DiaryColorCell.self)) { indexPath, type, cell in
                cell.update(with: type)
            }
            .disposed(by: self.disposeBag)
    }
    
}

private extension AddGroupViewController {
    // 바텀 시트 표출 애니메이션
    func showBottomSheet() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.bottomSheetView.snp.updateConstraints { make in
                make.height.equalTo(self.view.frame.height - 86.0)
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // 바텀 시트 사라지는 애니메이션
    func hideBottomSheetAndGoBack() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.bottomSheetView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    func setupGestureRecognizer() {
        // 흐린 부분 탭할 때, 바텀시트를 내리는 TapGesture
        let tapGestue = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        self.dimmendView.addGestureRecognizer(tapGestue)
        self.dimmendView.isUserInteractionEnabled = true
    }
    
    // UITapGestureRecognizer 연결 함수 부분
    @objc func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
    }
    
    //textField UnderLine 그리기
    func drawUnderLine() {
        let border = CALayer()
        border.frame = CGRect(
            x: 0,
            y: self.inputTitleTextField.frame.size.height + 5.0,
            width: self.inputTitleTextField.frame.width, height: 1
        )
        border.borderWidth = 1
        border.backgroundColor = UIColor.black.cgColor
        self.inputTitleTextField.layer.addSublayer(border)
    }
    
    @objc func didTapDismissButton() {
        hideBottomSheetAndGoBack()
    }
}


import SwiftUI
struct AddGroupViewController_Priviews: PreviewProvider {
    static var previews: some View {
        Contatiner().edgesIgnoringSafeArea(.all)
    }
    struct Contatiner: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            let vc = AddGroupViewController() //보고 싶은 뷰컨 객체
            return UINavigationController(rootViewController: vc)
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        typealias UIViewControllerType =  UIViewController
    }
}
