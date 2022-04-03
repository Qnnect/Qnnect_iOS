//
//  CafeAnswerWritingViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/08.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import PhotosUI

final class WriteCommentViewController: BaseViewController {
    
    private let questionView = UIView().then {
        $0.layer.cornerRadius = 16.0
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.brownBorderColor?.cgColor
    }
    
    private let dateLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 10.0)
        $0.textColor = .GRAY02
    }
    
    private let questionerLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 12.0)
        $0.textColor = .BLACK_121212
    }
    
    private let daysLeftLabel = BasePaddingLabel(padding: UIEdgeInsets(top: 7.0, left: 9.0, bottom: 7.0, right: 9.0)).then {
        $0.font = .IM_Hyemin(.bold, size: 10.0)
        $0.textColor = .BLACK_121212
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.BLACK_121212?.cgColor
        $0.layer.cornerRadius = 12.0
    }
    
    private let contentLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.textColor = .BLACK_121212
        $0.numberOfLines = 0
    }
    
    private let writerProfileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 27.0 / 2.0
        $0.clipsToBounds = true
    }
    
    private let writerNameLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.textColor = .BLACK_121212
    }
    
    private let inputTextView = UITextView().then {
        $0.isScrollEnabled = false
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.text = "답변을 입력하세요"
        $0.textColor = .GRAY04
        $0.sizeToFit()
        $0.backgroundColor = .p_ivory
        $0.autocorrectionType = .no
    }
    
    private let attachingImageButton = UIButton().then {
        $0.setImage(Constants.attachingImageIcon, for: .normal)
    }
    
    private lazy var bottomBar = UIToolbar(frame: .init(x: 0, y: 0, width: 100.0, height: 100.0)).then {
        $0.setItems([UIBarButtonItem(customView: self.attachingImageButton),UIBarButtonItem.flexibleSpace()], animated: true)
        $0.barTintColor = .p_ivory
    }
    
    private let navigationCompletionButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.GRAY04, for: .normal)
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        $0.isEnabled = false
    }
    
    private let navigationTitleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .GRAY01
    }
    
    private let attachingImageCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    ).then {
        $0.backgroundColor = .p_ivory
        $0.register(
            AttachingImageCell.self,
            forCellWithReuseIdentifier: AttachingImageCell.identifier
        )
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 85, height: 85)
        layout.scrollDirection = .horizontal
        $0.collectionViewLayout = layout
        $0.showsHorizontalScrollIndicator = false
    }
    
    private var fetchedAssets: [PHAsset] = []
    
    private var cafeQuestionId: Int!
    //private var cafeId: Int!
    private var user: User?
    private var viewModel: WriteCommentViewModel!
    weak var coordinator: WriteCommentCoordinator?
    private var comment: Comment?
    
    static func create(
        with cafeQuestionId: Int,
        _ user: User?,
        _ viewModel: WriteCommentViewModel,
        _ coordinator: WriteCommentCoordinator,
        _ comment: Comment? = nil
    ) -> WriteCommentViewController {
        let vc = WriteCommentViewController()
        vc.cafeQuestionId = cafeQuestionId
        vc.user = user
        vc.viewModel = viewModel
        vc.coordinator = coordinator
        vc.comment = comment
        return vc
    }
    
    private var imageDatas = [(PHAsset?,String?)]()
    private var images = [Double: UIImage?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
        [
            self.dateLabel,
            self.daysLeftLabel,
            self.questionerLabel,
            self.contentLabel
        ].forEach {
            self.questionView.addSubview($0)
        }
        
        [
            self.questionView,
            self.writerProfileImageView,
            self.writerNameLabel,
            self.inputTextView,
            self.bottomBar,
            self.attachingImageCollectionView
        ].forEach {
            self.view.addSubview($0)
        }
        
        self.questionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(14.0)
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.height.equalTo(152.0)
        }
        
        self.dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24.0)
            make.centerX.equalToSuperview()
        }
        
        self.questionerLabel.snp.makeConstraints { make in
            make.top.equalTo(self.dateLabel.snp.bottom).offset(1.0)
            make.centerX.equalToSuperview()
        }
        
        self.daysLeftLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16.0)
            make.trailing.equalToSuperview().inset(19.0)
        }
        
        self.contentLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.top.greaterThanOrEqualToSuperview().offset(8.0)
            make.trailing.bottom.lessThanOrEqualToSuperview().offset(8.0)
        }
        
        self.writerProfileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20.0)
            make.top.equalTo(self.questionView.snp.bottom).offset(30.0)
            make.width.height.equalTo(27.0)
        }
        
        self.writerNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.writerProfileImageView.snp.trailing).offset(8.0)
            make.centerY.equalTo(self.writerProfileImageView)
        }

        self.inputTextView.snp.makeConstraints { make in
            make.top.equalTo(self.writerProfileImageView.snp.bottom).offset(8.0)
            make.leading.trailing.equalToSuperview().inset(20.0)
        }
        
        inputTextView.delegate = self
        
        self.bottomBar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(50.0)
        }
        
        self.attachingImageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.inputTextView.snp.bottom).offset(15.0)
            make.leading.equalTo(self.inputTextView)
            make.trailing.equalToSuperview()
            make.height.equalTo(85.0)
        }
        
        self.attachingImageCollectionView.dataSource = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(bottomBarMoveUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(bottomBarMoveDown), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.navigationCompletionButton)
        navigationItem.titleView = navigationTitleLabel
        
        setScene(by: comment == nil ? WriteCommentType.create : WriteCommentType.modify )
    }
    
    override func bind() {
        
        
        let input = WriteCommentViewModel.Input(
            content: self.inputTextView.rx.text.orEmpty
                .asObservable(),
            didTapAttachingImageButton: self.attachingImageButton.rx.tap.asObservable(),
            didTapCompletionButton: navigationCompletionButton.rx.tap
                .throttle(.seconds(2), latest: false, scheduler: MainScheduler.instance)
                .debug()
                .do {
                    _ in
                    LoadingIndicator.showLoading()
                }
                .map(getImages),
            cafeQuestionId: Observable.just(cafeQuestionId),
            type: Observable.just(
                comment == nil ? WriteCommentType.create : WriteCommentType.modify
            ),
            comment: Observable.just(comment)
        )
        
        let output = self.viewModel.transform(from: input)
        
        output.isInputCompleted
            .drive(onNext: self.setCompletionButton(_:))
            .disposed(by: self.disposeBag)
        
        output.showImagePickerView
            .emit(onNext: {
                [weak self] _ in
                let selectionLimit = 5 - (self?.attachingImageCollectionView.numberOfItems(inSection: 0) ?? 5)
                if selectionLimit > 0 {
                    self?.checkPermission(selectionLimit: selectionLimit, true)
                }
            }).disposed(by: self.disposeBag)
        
        output.question
            .drive(onNext: setQuestionLayout(_:))
            .disposed(by: self.disposeBag)
        
        guard let coordinator = coordinator else { return }

        //TODO: 화면전환
        output.completion
            .debug()
            .do {
                _ in
                LoadingIndicator.hideLoading()
            }
            .emit(onNext: coordinator.pop)
            .disposed(by: self.disposeBag)
        
        //Modify 화면 일 경우
        guard let comment = comment else { return }
        imageDatas = comment.getImageURLs().map { (nil,$0)}
        
    }
    
    override func imagePicker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let identifiers = results.map{ $0.assetIdentifier ?? ""}
        let result = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
       
        for i in 0 ..< result.count {
            imageDatas.append((result[i],nil))
            attachingImageCollectionView.insertItems(at: [IndexPath(row: imageDatas.count - 1, section: 0)])
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension WriteCommentViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .GRAY04 {
            textView.text = nil
            textView.textColor = .BLACK_121212
        }
        
    }
    // TextView Place Holder
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "답변을 입력하세요"
            textView.textColor = .GRAY04
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let str = textView.text else { return true }
        let newLength = str.count + text.count - range.length
        return newLength <= 100
    }
    
}

// MARK: - UICollectionView DataSource
extension WriteCommentViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDatas.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: AttachingImageCell.identifier, for: indexPath) as! AttachingImageCell

        let key = Date().timeIntervalSince1970
        //let asset = self.fetchedAssets[indexPath.row]
        if let asset = imageDatas[indexPath.row].0 {
            
            cell.update(with: asset) {
                [weak self] image in
                self?.images[key] = image
            }
        } else if let url = imageDatas[indexPath.row].1 {
            cell.update(with: url) {
                [weak self] image in
                self?.images[key] = image
            }
        }
        
        cell.delegate = self

        return cell
    }
}

private extension WriteCommentViewController {
    @objc func bottomBarMoveUp(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3, animations: {
                self.bottomBar.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
            }
            )
        }
    }
    
    @objc func bottomBarMoveDown(_ notification: NSNotification) {
        self.bottomBar.transform = .identity
    }
    
    func setCompletionButton(_ isCompleted: Bool) {
        if isCompleted {
            self.navigationCompletionButton.setTitleColor(.ORANGE01, for: .normal)
            self.navigationCompletionButton.isEnabled = true
        } else {
            self.navigationCompletionButton.setTitleColor(.GRAY04, for: .normal)
            self.navigationCompletionButton.isEnabled = false
        }
    }
    
    func getImages() -> [Data?] {
        return images.sorted(by: { $0.key < $1.key }).map { $0.value?.jpegData(compressionQuality: 1.0) }
    }
    
    func setScene(by type: WriteCommentType) {
        switch type {
        case .create:
            guard let user = user else { return }
            navigationTitleLabel.text = "답변 쓰기"
            if let url = user.profileImage {
                self.writerProfileImageView.kf.setImage(
                    with: URL(string: url),
                    placeholder: Constants.profileDefaultImage
                )
            } else {
                self.writerProfileImageView.image = Constants.profileDefaultImage
            }
            self.writerNameLabel.text = user.name
        case .modify:
            guard let comment = comment else { return }
            navigationTitleLabel.text = "답변 수정"
            if let url = comment.writerInfo.profileImage {
                self.writerProfileImageView.kf.setImage(
                    with: URL(string: url),
                    placeholder: Constants.profileDefaultImage
                )
            } else {
                self.writerProfileImageView.image = Constants.profileDefaultImage
            }
            self.writerNameLabel.text = comment.writerInfo.name
            inputTextView.text = comment.content
            inputTextView.textColor = .BLACK_121212
        }
    }
    
    func setQuestionLayout(_ question: Question) {
        questionView.backgroundColor = question.questioner == "넥트" ? .SECONDARY01 : .ORANGE01
        dateLabel.text = question.createdAt
        questionerLabel.text = question.questioner == "넥트" ? "" : "\(question.questioner)의 질문"
        daysLeftLabel.text = "D-\(question.daysLeft)"
        contentLabel.attributedText = NSAttributedString(
            string: question.content,
            attributes: [NSAttributedString.Key.paragraphStyle: Constants.paragraphStyle]
        )
    }
}

extension WriteCommentViewController: AttachingImageCellDelegate {
    func attachingImageCell(didTap cell: UICollectionViewCell) {
        guard let indexPath = self.attachingImageCollectionView.indexPath(for: cell) else { return }
        
        imageDatas.remove(at: indexPath.row)
        var sortedImages = images.sorted(by: { $0.key < $1.key })
        sortedImages.remove(at: indexPath.row)
        images = Dictionary(uniqueKeysWithValues: sortedImages)
        self.attachingImageCollectionView.deleteItems(at: [indexPath])
    }
}
