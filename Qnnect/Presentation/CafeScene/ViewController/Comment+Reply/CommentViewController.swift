//
//  CommentViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/14.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxDataSources
import MessageUI
import ImageSlideshow

final class CommentViewController: BaseViewController {
    
    private let mainCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    ).then {
        $0.register(CommentCell.self, forCellWithReuseIdentifier: CommentCell.identifier)
        $0.register(CommentAttachImageCell.self, forCellWithReuseIdentifier: CommentAttachImageCell.identifier)
        $0.register(ReplyCell.self, forCellWithReuseIdentifier: ReplyCell.identifier)
        $0.register(CommentDateCell.self, forCellWithReuseIdentifier: CommentDateCell.identifier)
        $0.backgroundColor = .p_ivory
    }
    
    private let bottomView = UIView().then {
        $0.backgroundColor = .p_ivory
        $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: -1.0)
        $0.layer.shadowOpacity = 1.0
        $0.layer.shadowRadius = 1.0
    }
    
    private let inputTextView = UITextView().then {
        $0.layer.cornerRadius = 10.0
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.secondaryBorder?.cgColor
        $0.backgroundColor = .p_ivory
        $0.textColor = .GRAY04
        $0.text = "댓글을 입력하세요"
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.contentInset = .init(top: 0, left: 10.0, bottom: 0, right: 0)
    }
    
    private let sendButton = UIButton().then {
        $0.setImage(Constants.sendButtonImage, for: .normal)
    }
    
    private let imageSlider = ImageSlideshow().then {
        $0.contentScaleMode = .scaleAspectFill
        //$0.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
    }
    
    private var viewModel: CommentViewModel!
    private var commentId: Int!
    weak var coordinator: CommentCoordinator?
    
    static func create(
        with viewModel: CommentViewModel,
        _ commentId: Int,
        _ coordinator: CommentCoordinator
    ) -> CommentViewController {
        let vc = CommentViewController()
        vc.viewModel = viewModel
        vc.commentId = commentId
        vc.coordinator = coordinator
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        
        [
            mainCollectionView,
            bottomView
        ].forEach {
            view.addSubview($0)
        }
        
        [
            inputTextView,
            sendButton
        ].forEach {
            bottomView.addSubview($0)
        }
        
        mainCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        bottomView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        inputTextView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24.0)
            make.top.equalToSuperview().inset(8.0)
            make.bottom.equalToSuperview().inset(24.0)
            make.height.equalTo(40.0)
        }
        inputTextView.delegate = self
        
        sendButton.snp.makeConstraints { make in
            make.leading.equalTo(inputTextView.snp.trailing).offset(6.0)
            make.width.height.equalTo(48.0)
            make.trailing.equalToSuperview().inset(20.0)
            //make.bottom.equalToSuperview().inset(21.3)
            make.centerY.equalTo(inputTextView)
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func bind() {
        super.bind()
        
        let didTapProfile = PublishSubject<User>()
        
        let input = CommentViewModel.Input(
            viewWillAppear: rx.viewWillAppear.mapToVoid(),
            commentId: Observable.just(commentId),
            didTapSendButton: sendButton.rx.tap
                .do {
                    [weak self] _ in
                    self?.inputTextView.text = ""
                }
                .withLatestFrom(inputTextView.rx.text.orEmpty)
                .asObservable(),
            didTapCommentMoreButton: rx.methodInvoked(#selector(didTapCommentMoreButton))
                .mapToVoid(),
            didTapReplyMoreButton: rx.methodInvoked(#selector(moreButton(didTap:_:)))
                .map {
                    return $0[1] as! Int
                },
            didTapProfile: didTapProfile.asObservable()
        )
        
        let output = viewModel.transform(from: input)
        
        let dataSource = createDataSource(didTapProfile: didTapProfile.asObserver())
        
        Observable.zip(
            output.comment.asObservable(),
            output.replies.asObservable()
        )
            .debug()
            .map {
                [weak self] comment, replies -> [CommentSectionModel] in
                guard let self = self else { return [] }
                var models = [CommentSectionModel]()
                let commentSectionItem = CommentSectionItem.commentSectionItem(comment: comment)
                let commentDateSectionItem = CommentSectionItem.createAtSectionItem(date: comment.createdAt)
                let replySectionItems = replies.map {  CommentSectionItem.replySectionItem(reply: $0) }
                
                models.append(CommentSectionModel.commentSection(title: "", items: [commentSectionItem]))
                if comment.getImageURLs().count > 0 {
                    self.imageSlider.setImageInputs(comment.getImageURLs().map {
                        KingfisherSource(urlString: $0)!
                    })
                    let attachImageSectionItems = comment.getImageURLs().map { CommentSectionItem.attachImageSectionItem(imageURL: $0) }
                    models.append( CommentSectionModel.attachImageSection(title: "", items: attachImageSectionItems))
                    if comment.getImageURLs().count == 1 {
                        print("set CollectionView SingleImage")
                        self.mainCollectionView.collectionViewLayout = self.createSingleImageLayout()
                    } else {
                        print("set CollectionView normal")
                        self.mainCollectionView.collectionViewLayout = self.createLayout()
                    }
                } else {
                    print("set CollectionView empytyImage")
                    self.mainCollectionView.collectionViewLayout = self.createEmptyImageLayout()
                }
                models.append(CommentSectionModel.createAtSection(title: "", items: [commentDateSectionItem]))
                models.append(CommentSectionModel.replySection(title: "", items: replySectionItems))
                print("models !!! \(models)")
                return models
            }
            .bind(to: mainCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        
        output.isWriter
            .drive(onNext: {
                [weak self] isWriter in
                guard let self = self else { return }
                if isWriter {
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Constants.navagation_more, style: .plain, target: self, action: #selector(self.didTapCommentMoreButton))
                }
            }).disposed(by: self.disposeBag)
        
        guard let coordinator = coordinator else { return }
        
        output.showCommentMoreMenuBottomSheet
            .emit(onNext: coordinator.showCommentMoreMenuBottomSheet)
            .disposed(by: self.disposeBag)
        
        output.showReplyMoreMenuBottomSheet
            .emit(onNext: coordinator.showReplyMoreMenuBottomSheet)
            .disposed(by: self.disposeBag)
        
        output.showReportBottomSheet
            .emit(onNext: coordinator.showReportBottomSheet)
            .disposed(by: self.disposeBag)
    }
}

private extension CommentViewController {
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout {
            [weak self] section, environment -> NSCollectionLayoutSection? in
            switch section {
            case 0:
                return self?.createCommentSection()
            case 1:
                return self?.createAttachImageSection()
            case 2:
                return self?.createCommentDateSection()
            case 3:
                return self?.createReplySection()
            default:
                return nil
            }
        }
    }
    
    func createEmptyImageLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout {
            [weak self] section, environment -> NSCollectionLayoutSection? in
            switch section {
            case 0:
                return self?.createCommentSection()
            case 1:
                return self?.createCommentDateSection()
            case 2:
                return self?.createReplySection()
            default:
                return nil
            }
        }
    }
    
    func createSingleImageLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout {
            [weak self] section, environment -> NSCollectionLayoutSection? in
            switch section {
            case 0:
                return self?.createCommentSection()
            case 1:
                return self?.createSingleAttachImageSection()
            case 2:
                return self?.createCommentDateSection()
            case 3:
                return self?.createReplySection()
            default:
                return nil
            }
        }
    }
    
    
    func createCommentSection() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: itemSize.heightDimension)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 25.0, leading: 24.0, bottom: 0, trailing: 0)
        
        return section
    }
    
    func createAttachImageSection() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        //group
        let spacingRadio = 8.0 / UIScreen.main.bounds.width
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0/3.0 - spacingRadio ))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.interItemSpacing = .fixed(12.0)
        group.contentInsets = .init(top: 0, leading: 12.0, bottom: 0, trailing: 0)
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 20.0, leading: 8.0, bottom: 16.0, trailing: 0)
        
        return section
    }
    
    func createSingleAttachImageSection() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        //group
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.53))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20.0, leading: 20.0, bottom: 10.0, trailing: 20.0)
        
        return section
    }
    
    func createReplySection() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .estimated(50.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: itemSize.heightDimension)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20.0, leading: 27.5, bottom: 0, trailing: 0)
        section.interGroupSpacing = 12.0
        return section
    }
    
    func createCommentDateSection() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .estimated(6.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: itemSize.heightDimension)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        //section
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    func createDataSource(didTapProfile: AnyObserver<User>) -> RxCollectionViewSectionedReloadDataSource<CommentSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<CommentSectionModel> {
            dataSource, collectionView, indexPath, item in
            print(dataSource.sectionModels)
            switch item {
            case .commentSectionItem(comment: let comment):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CommentCell.identifier,
                    for: indexPath
                ) as! CommentCell
                cell.update(with: comment)
                cell.bind(with: didTapProfile)
                return cell
            case .attachImageSectionItem(imageURL: let imageURL):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CommentAttachImageCell.identifier,
                    for: indexPath
                ) as! CommentAttachImageCell
                cell.update(with: imageURL)
                cell.delegate = self
                return cell
            case .replySectionItem(reply: let reply):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ReplyCell.identifier,
                    for: indexPath
                ) as! ReplyCell
                cell.update(with: reply)
                cell.delegate = self
                cell.bind(with: didTapProfile)
                return cell
            case .createAtSectionItem(date: let date):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CommentDateCell.identifier,
                    for: indexPath
                ) as! CommentDateCell
                cell.update(with: date)
                return cell
            }
        }
    }
}

extension CommentViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .GRAY04 {
            textView.text = nil
            textView.textColor = .BLACK_121212
        }
        
    }
    // TextView Place Holder
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "댓글을 입력하세요"
            textView.textColor = .GRAY04
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let str = textView.text else { return true }
        let newLength = str.count + text.count - range.length
        return newLength <= 50
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.contentSize.height <= 40{
            inputTextView.snp.updateConstraints { make in
                make.height.equalTo(40)
            }
        }else if textView.contentSize.height >= 100{
            inputTextView.snp.updateConstraints { make in
                make.height.equalTo(100)
            }
        }else{
            inputTextView.snp.updateConstraints { make in
                make.height.equalTo(textView.contentSize.height)
            }
        }
    }
}

extension CommentViewController{
    @objc func keyboardWillShow(noti : Notification){
        let notiInfo = noti.userInfo!
        let keyboardFrame = notiInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        
        UIView.animate(withDuration: animationDuration) {
            [weak self] in
            guard let self = self else {return}
            self.inputTextView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().inset(keyboardFrame.size.height + 8.0)
            }
            self.view.layoutIfNeeded()
        }
    }
    @objc func keyboardDidHide(noti : Notification){
        let notiInfo = noti.userInfo!
        let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        
        UIView.animate(withDuration: animationDuration) {
            [weak self] in
            self?.inputTextView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().inset(24.0)
            }
            self?.view.layoutIfNeeded()
        }
    }
}

private extension CommentViewController {
    @objc dynamic func didTapCommentMoreButton() { }
}

extension CommentViewController: ReplyMoreButtonDelegate {
    func moreButton(didTap cell: UICollectionViewCell, _ replyId: Int) {
        print("test", replyId)
    }
}

extension CommentViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension CommentViewController: CommentAttachImageCellDelegate {
    func didTapAttachImageCell(didTap cell: UICollectionViewCell) {
        imageSlider.setCurrentPage(mainCollectionView.indexPath(for: cell)?.row ?? 0, animated: false)
        imageSlider.presentFullScreenController(from: self, completion: nil)
    }
}
