//
//  CafeAnswerViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/08.
//

import Foundation
import RxSwift
import RxCocoa

final class CafeQuestionViewModel: ViewModelType {
    
    struct Input {
        let didTapAnswerWritingCell: Observable<Void>
        /// Bool: true: 스크랩하기 , false: 스크랩 취소하기
        let didTapScrapButton: Observable<Bool>
        let questionId: Observable<Int>
        let viewWillAppear: Observable<Void>
        let didTapAnswerCell: Observable<Comment>
        /// Bool: true: 좋아요 취소 , false: 좋아요 하기
        let didTapLikeButton: Observable<Bool>
        let didTapModifyButton: Observable<Void>
        let didTapDeleteButton: Observable<Void>
        let didTapDeleteAlertOkButton: Observable<Void>
        let didTapProfile: Observable<User>
    }
    
    struct Output {
        ///Int: CafeQuestionId
        let showWriteCommentScene: Signal<(Int,User)>
        let scrap: Signal<Void>
        let cancleScrap: Signal<Void>
        let comments: Driver<[Comment]>
        let question: Driver<Question>
        ///Int: CommentId
        let showCommentScene: Signal<Int>
        let user: Driver<User>
        let currentUserComment: Driver<Comment?>
        let like: Signal<Void>
        let liked: Driver<Bool>
        let showDeleteAlertView: Signal<Void>
        let delete: Signal<Void>
        let showModeifyQuestionScene: Signal<Question>
        let showReportBottomSheet: Signal<User>
        let fetchError: Signal<Void>
    }
    
    private let questionUseCase: QuestionUseCase
    private let userUseCase: UserUseCase
    
    init(
        questionUseCase: QuestionUseCase,
        userUseCase: UserUseCase
    ) {
        self.questionUseCase = questionUseCase
        self.userUseCase = userUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let fetchedResult = input.viewWillAppear
            .withLatestFrom(input.questionId)
            .flatMap(questionUseCase.fetchQuestion(_:))
            .share()
        
        let fetchedQuestionWithComments = fetchedResult.compactMap { result -> CafeQuestion? in
            guard case let .success(cafeQuestion) = result else { return nil }
            return cafeQuestion
        }
       
        let fetchError = fetchedResult.filter { result in
            guard case .failure(_) = result else { return false }
            return true
        }.mapToVoid()
        
        let user = input.viewWillAppear
            .flatMap(userUseCase.fetchUser)
            .compactMap{
                result -> User? in
                guard case let .success(user) = result else { return nil}
                return user
            }
        
        let fetchedQuestion = fetchedQuestionWithComments.map { $0.question }
        let liked = fetchedQuestionWithComments.map { $0.liked }
        let scraped = fetchedQuestionWithComments.map { $0.scraped }
        let currentUserComment = fetchedQuestionWithComments.map {
            question -> Comment? in
            var comment = question.currentUserComment
            comment?.writer = true
            return comment
        }
        
        let showWriteCommentScene = input.didTapAnswerWritingCell
            .withLatestFrom(Observable.combineLatest(fetchedQuestion.map { $0.id }, user))
        
        
        let scrapTrigger = input.didTapScrapButton
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .share()
        
        let scrap = scrapTrigger
            .filter { $0 }
            .withLatestFrom(fetchedQuestion.map{ $0.id })
            .flatMap(self.questionUseCase.scrap)
            .compactMap {
                result -> Void? in
                guard case .success(_) = result else { return nil }
                return Void()
            }
        
        let cancleScrap = scrapTrigger
            .filter{ !$0 }
            .withLatestFrom(fetchedQuestion.map{ $0.id })
            .flatMap(self.questionUseCase.cancleScrap)
            .compactMap {
                result -> Void? in
                guard case .success(_) = result else { return nil }
                return Void()
            }
        
        
        let showCommentScene = input.didTapAnswerCell
            .map { $0.id }
            
        
        let like = input.didTapLikeButton
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .debug()
            .withLatestFrom(input.questionId, resultSelector: { ($1, $0)})
            .flatMap(self.questionUseCase.like)
            .debug()
            .compactMap { result -> Void? in
                guard case .success(_) = result else { return nil }
                return Void()
            }
        
        let showDeleteAlertView = input.didTapDeleteButton
        
        //TODO: 에러든 성공이든 화면전환을 위해 mapToVoid 나중에 에러처리 필요
        let deleteQuestion = input.didTapDeleteAlertOkButton
            .withLatestFrom(input.questionId)
            .flatMap(questionUseCase.deleteQuestion(_:))
            .mapToVoid()
        
        let showModifyQuestionScene = input.didTapModifyButton
            .withLatestFrom(fetchedQuestionWithComments.map { $0.question} )
        
        let showReportBottomSheet = input.didTapProfile
           
        
        return Output(
            showWriteCommentScene: showWriteCommentScene.asSignal(onErrorSignalWith: .empty()),
            scrap: Observable.merge(
                scrap,
                scraped.filter{ $0 }.mapToVoid()
            ).asSignal(onErrorSignalWith: .empty()),
            cancleScrap: cancleScrap.asSignal(onErrorSignalWith: .empty()),
            comments: fetchedQuestionWithComments.map { $0.comments }.asDriver(onErrorJustReturn: []),
            question: fetchedQuestionWithComments.map { $0.question }.asDriver(onErrorDriveWith: .empty()),
            showCommentScene: showCommentScene.asSignal(onErrorSignalWith: .empty()),
            user: user.asDriver(onErrorDriveWith: .empty()),
            currentUserComment: currentUserComment.asDriver(onErrorDriveWith: .empty()),
            like: like.asSignal(onErrorSignalWith: .empty()),
            liked: liked.asDriver(onErrorDriveWith: .empty()),
            showDeleteAlertView: showDeleteAlertView.asSignal(onErrorSignalWith: .empty()),
            delete: deleteQuestion.asSignal(onErrorSignalWith: .empty()),
            showModeifyQuestionScene: showModifyQuestionScene.asSignal(onErrorSignalWith: .empty()),
            showReportBottomSheet: showReportBottomSheet.asSignal(onErrorSignalWith: .empty()),
            fetchError: fetchError.asSignal(onErrorSignalWith: .empty())
        )
    }
}
