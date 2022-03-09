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


final class AddCafeViewController: CafeInfoInputViewController {
    
    private var viewModel: AddCafeViewModel!
    
    static func create(with viewModel: AddCafeViewModel) -> AddCafeViewController {
        let vc = AddCafeViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureUI() {
        super.configureUI()
        self.titleLabel.text = "카페 만들기"
    }
    
    override func bind() {
        super.bind()

        let value = self.questionCycleSlider.slider.rx.methodInvoked(#selector(self.questionCycleSlider.slider.endTracking(_:with:)))
            .map{ [weak self] _ -> QuestionCycle in
                guard let self = self else { return .every }
                return self.questionCycleSlider.slider.selectedCycle
            }.startWith(.every)
        
        let input = AddCafeViewModel.Input(
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
                .map(self.getSelectedDiaryColor),
            didTapNextButton: self.nextButton.rx.tap
                .mapToVoid()
        )
        
        
        let output = self.viewModel.transform(from: input)
        
        output.isValidName
            .emit(onNext: { print($0)})
            .disposed(by: self.disposeBag)
        
        output.isCompleted
            .emit(onNext: self.setEnablementNextButton(_:))
            .disposed(by: self.disposeBag)
        
        output.showGroupScene
            .emit(onNext: self.dismiss)
            .disposed(by: self.disposeBag)
    }
    
}
