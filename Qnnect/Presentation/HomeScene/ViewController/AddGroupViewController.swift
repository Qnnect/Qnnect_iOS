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

enum DiaryColorType: String, CaseIterable{
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

final class AddGroupViewController: BottomSheetViewController {
    
    
    
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
    
    private let diaryColorCollectionView = DiaryColorCollectionView(
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
        $0.allowsSelection = true
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
    
    private var viewModel: AddGroupViewModel!
    
    static func create(with viewModel: AddGroupViewModel) -> AddGroupViewController{
        let vc = AddGroupViewController()
        vc.viewModel = viewModel
        return vc
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.drawUnderLine()
        self.questionCycleSlider.update(with: QuestionCycle.allCases)
    }
    
    override func configureUI() {
        
        [

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
        //self.view.backgroundColor = .black.withAlphaComponent(0.5)
        self.inputTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.dismissButton.snp.bottom).offset(22.0)
            make.leading.trailing.equalToSuperview().inset(Constants.bottomSheetHorizontalMargin)
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
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(20.0)
        }
    }
    
    override func bind() {
        
        //diaryColorCollectionView 그리기
        Observable.just(DiaryColorType.allCases)
            .bind(to: self.diaryColorCollectionView.rx.items(cellIdentifier: DiaryColorCell.identifier, cellType: DiaryColorCell.self)) { indexPath, type, cell in
                cell.update(with: type)
            }
            .disposed(by: self.disposeBag)
        
        let value = self.questionCycleSlider.slider.rx.methodInvoked(#selector(self.questionCycleSlider.slider.endTracking(_:with:)))
            .map{ [weak self] _ -> Int in
                guard let self = self else { return 0 }
                return self.questionCycleSlider.slider.selectedIndex
            }
        
        let input = AddGroupViewModel.Input(
            selectedCycle: value,
            inputName: self.inputTitleTextField.rx.text.orEmpty
                .asObservable(),
            selectedGroupType: self.groupTypeTagCollectionView.rx.tappedTagTitle
                .map { title -> GroupType in
                    for type in GroupType.allCases {
                        if type.title == title {
                            return type
                        }
                    }
                    return .friend // default or thrash
                },
            selectedDiaryColor: self.diaryColorCollectionView.rx.itemSelected
                .do(onNext: self.changeDiaryColorCellState(_:))
                .map(self.getSelectedDiaryColorString),
            didTapNextButton: self.nextButton.rx.tap
                .mapToVoid()
        )
        
        
        let output = self.viewModel.transform(from: input)
        
        output.questionCycle
            .drive(
                onNext: {
                    print($0)
                }
            )
            .disposed(by: self.disposeBag)
        
        output.isValidName
            .emit(onNext: { print($0)})
            .disposed(by: self.disposeBag)
        
        output.isCompleted
            .emit(onNext: self.setEnablementNextButton(_:))
            .disposed(by: self.disposeBag)
        
        output.showSelectDrinkBottomSheet
            .emit()
            .disposed(by: self.disposeBag)
    }
    
}

private extension AddGroupViewController {

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
    
    //선택된 DiaryColor Cell 선택 상태 변경
    func changeDiaryColorCellState(_ indexPath: IndexPath) {
        let cell = self.diaryColorCollectionView.cellForItem(at: indexPath) as! DiaryColorCell
        cell.isChosen.toggle()
        self.diaryColorCollectionView.lastSelectedCell?.isChosen.toggle()
        self.diaryColorCollectionView.lastSelectedCell = cell
    }

    
    /// 선택된 DiaryColorCell 의 색상 이름을 조회하는 함수
    /// - Parameter indexPath: 선택된 Cell의 IndexPath
    /// - Returns: 색상 이름
    func getSelectedDiaryColorString(_ indexPath: IndexPath) -> String {
        let cell = self.diaryColorCollectionView.cellForItem(at: indexPath) as! DiaryColorCell
        return cell.type?.rawValue ?? DiaryColorType.brown.rawValue
    }
    
    /// 모든 항목의 유효한 입력이 왼료됐는 지 에 따라 button 활성화 결정
    /// - Parameter isCompleted: 모든 항목 유요한 항목 입력 했는 지 여부
    func setEnablementNextButton(_ isCompleted: Bool) {
        self.nextButton.isEnabled = isCompleted
        self.nextButton.backgroundColor = isCompleted ? .p_brown : .GRAY04
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
