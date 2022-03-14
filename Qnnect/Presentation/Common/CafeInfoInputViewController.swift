//
//  CafeInfoInputViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/09.
//

import UIKit
import SnapKit
import Then
import RxSwift
import TTGTags


class CafeInfoInputViewController: BottomSheetViewController {
    
    private(set) var inputTitleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .GRAY01
        $0.text = "제목을 입력해주세요"
    }
    
    private(set) var inputTitleTextField = UITextField().then {
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.textColor = .GRAY01
        $0.placeholder = "10자 이내"
    }
    
    private(set) var titleCautionLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 12.0)
        $0.textColor = .redLabel
        $0.text = Constants.titleCaution
    }
    
    private(set) var groupTypeLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .GRAY01
        $0.text = "누구와 함께 하나요?"
    }
    
    private(set) var groupTypeTagCollectionView = CustomTagCollectionView().then {
        $0.update(with: GroupType.allCases.map{$0.title})
    }
    
    private(set) var diaryColorLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .GRAY01
        $0.text = "다이어리 색상을 골라주세요"
    }
    
    private(set) var diaryColorCollectionView = DiaryColorCollectionView(
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
    
    private(set) var questionCycleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .GRAY01
        $0.text = "질문 주기를 선택해주세요"
    }
    
    private(set) var questionCycleSlider = QuestionCycleSlider().then {
        $0.slider.maximumTrackTintColor = .GRAY05
        $0.slider.minimumTrackTintColor = .p_brown
    }
    
    private(set) var completionButton = UIButton().then {
        $0.isEnabled = false
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        $0.setTitleColor(.WHITE_FFFFFF, for: .normal)
        $0.backgroundColor = .GRAY04
        $0.layer.cornerRadius = 10.0
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
            titleCautionLabel,
            self.groupTypeLabel,
            self.groupTypeTagCollectionView,
            self.diaryColorLabel,
            self.diaryColorCollectionView,
            self.questionCycleLabel,
            self.questionCycleSlider,
            self.completionButton
        ].forEach {
            self.bottomSheetView.addSubview($0)
        }
        
        self.topPadding = 121.0
        
        //self.view.backgroundColor = .black.withAlphaComponent(0.5)
        self.inputTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.dismissButton.snp.bottom).offset(22.0)
            make.leading.trailing.equalToSuperview().inset(Constants.bottomSheetHorizontalMargin)
        }
        
        self.inputTitleTextField.snp.makeConstraints { make in
            make.top.equalTo(self.inputTitleLabel.snp.bottom).offset(16.0)
            make.leading.trailing.equalTo(self.inputTitleLabel)
        }
        
        titleCautionLabel.snp.makeConstraints { make in
            make.leading.equalTo(inputTitleTextField)
            make.top.equalTo(inputTitleTextField.snp.bottom).offset(11.0)
            make.height.equalTo(0)
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
        
        self.completionButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.inputTitleLabel)
            make.height.equalTo(Constants.bottomButtonHeight)
            make.top.equalTo(self.questionCycleSlider.snp.bottom).offset(69.0)
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

extension CafeInfoInputViewController {

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
    func getSelectedDiaryColor(_ indexPath: IndexPath) -> DiaryColorType {
        let cell = self.diaryColorCollectionView.cellForItem(at: indexPath) as! DiaryColorCell
        return cell.type ?? .red
    }
    
    /// 모든 항목의 유효한 입력이 왼료됐는 지 에 따라 button 활성화 결정
    /// - Parameter isCompleted: 모든 항목 유요한 항목 입력 했는 지 여부
    func setEnablementNextButton(_ isCompleted: Bool) {
        self.completionButton.isEnabled = isCompleted
        self.completionButton.backgroundColor = isCompleted ? .p_brown : .GRAY04
    }
    
    func setCautionLabel(_ isVaild: Bool) {
        UIView.animate(withDuration: 0.5) {
            [weak self] in
            if isVaild {
                self?.titleCautionLabel.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
            } else {
                self?.titleCautionLabel.snp.updateConstraints { make in
                    make.height.equalTo(18.0)
                }
            }
            self?.view.layoutIfNeeded()
        }
    }
    
    func dismiss() {
        self.dismiss(animated: false, completion: nil)
    }
}
