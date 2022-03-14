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

final class CommentViewController: BaseViewController {
    
    private let mainCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    ).then {
        $0.register(CommentCell.self, forCellWithReuseIdentifier: CommentCell.identifier)
        $0.register(CommentAttachImageCell.self, forCellWithReuseIdentifier: CommentAttachImageCell.identifier)
        $0.register(ReplyCell.self, forCellWithReuseIdentifier: ReplyCell.identifier)
        $0.backgroundColor = .p_ivory
    }
    
    //    private let moreButton = UIButton().then {
    //        $0.setImage(Constants.navagation_more, for: .normal)
    //    }
    
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
    
    private var viewModel: CommentViewModel!
    private var commentId: Int!
    
    static func create(
        with viewModel: CommentViewModel,
        _ commentId: Int
    ) -> CommentViewController {
        let vc = CommentViewController()
        vc.viewModel = viewModel
        vc.commentId = commentId
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
        
        mainCollectionView.collectionViewLayout = createLayout()
        
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Constants.navagation_more, style: .plain, target: nil, action: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func bind() {
        super.bind()
        
        let input = CommentViewModel.Input(
            viewDidLoad: Observable.just(()),
            commentId: Observable.just(commentId)
        )
        
        let output = viewModel.transform(from: input)
        
        output.comment
            .drive(onNext: {
                print("comment",$0)
            }).disposed(by: self.disposeBag)
        
        output.replies
            .drive(onNext: {
                print("replies",$0)
            }).disposed(by: self.disposeBag)
        
        let dataSource = createDataSource()
        Observable.combineLatest(
            output.comment.asObservable(),
            output.replies.asObservable()
        ).map {
            comment, replies -> [CommentSectionModel] in
            let commentSectionItem = CommentSectionItem.commentSectionItem(comment: comment)
            let attachImageSectionItems = comment.getImageURLs().map { CommentSectionItem.attachImageSectionItem(imageURL: $0) }
            let replySectionItems = replies.map {  CommentSectionItem.replySectionItem(reply: $0) }
            
            return [
                CommentSectionModel.commentSection(title: "", items: [commentSectionItem]),
                CommentSectionModel.attachImageSection(title: "", items: attachImageSectionItems),
                CommentSectionModel.replySection(title: "", items: replySectionItems)
            ]
        }.bind(to: mainCollectionView.rx.items(dataSource: dataSource))
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
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(102.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.interItemSpacing = .fixed(12.0)
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 19.0, leading: 24.0, bottom: 0, trailing: 0)
        
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
        section.contentInsets = .init(top: 21.0, leading: 27.5, bottom: 0, trailing: 0)
        section.interGroupSpacing = 12.0
        return section
    }
    
    func createDataSource() -> RxCollectionViewSectionedReloadDataSource<CommentSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<CommentSectionModel> {
            dataSource, collectionView, indexPath, item in
            switch item {
            case .commentSectionItem(comment: let comment):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CommentCell.identifier,
                    for: indexPath
                ) as! CommentCell
                cell.update(with: comment)
                return cell
            case .attachImageSectionItem(imageURL: let imageURL):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CommentAttachImageCell.identifier,
                    for: indexPath
                ) as! CommentAttachImageCell
                cell.update(with: imageURL)
                return cell
            case .replySectionItem(reply: let reply):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ReplyCell.identifier,
                    for: indexPath
                ) as! ReplyCell
                cell.update(with: reply)
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
