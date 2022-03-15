//
//  CafeModifyViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/09.
//

import UIKit
import SnapKit
import Then
import RxSwift


final class CafeModifyingViewController: CafeInfoInputViewController {
    
    private var cafeId: Int!
    private var viewModel: CafeModifyingViewModel!
    weak var coordinator: CafeCoordinator?
    
    static func create(
        with viewModel: CafeModifyingViewModel,
        _ cafeId: Int,
        _ coordinator: CafeCoordinator
    ) -> CafeModifyingViewController {
        let vc = CafeModifyingViewController()
        vc.viewModel = viewModel
        vc.cafeId = cafeId
        vc.coordinator = coordinator
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        self.titleLabel.text = "카페 수정하기"
    }
    
    override func bind() {
        super.bind()
        
        let value = self.questionCycleSlider.slider.rx.methodInvoked(#selector(self.questionCycleSlider.slider.endTracking(_:with:)))
            .map{ [weak self] _ -> QuestionCycle in
                guard let self = self else { return .every }
                return self.questionCycleSlider.slider.selectedCycle
            }.startWith(.every)
        
        let input = CafeModifyingViewModel.Input(
            selectedCycle: value,
            inputName: self.inputTitleTextField.rx.text.orEmpty
                .skip(while: { ($0.count) == 0})
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
                .map(self.getSelectedDiaryColor),
            didTapCompletionButton: self.completionButton.rx.tap
                .mapToVoid(),
            cafeId: Observable.just(cafeId)
        )
        
        let output = self.viewModel.transform(from: input)
        
        output.isCompleted
            .emit(onNext: self.setEnablementNextButton(_:))
            .disposed(by: self.disposeBag)
        
        output.isValidName
            .emit(onNext: setCautionLabel(_:))
            .disposed(by: self.disposeBag)
        
        guard let coordinator = coordinator else { return }

        //TODO:
        output.dismiss
            .emit(onNext: coordinator.dismissDrinkSelectBottomSheet)
            .disposed(by: self.disposeBag)
    }
}
