//
//  NotificationListViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/22.
//

import Foundation
import RxSwift
import RxCocoa

enum NotiFetchAction {
    case load(notis: [NotificationInfo])
    case loadMore(notis: [NotificationInfo])
}
final class NotificationListViewModel: ViewModelType {
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let moreFetch: Observable<Int>
        let didTapNotification: Observable<NotificationInfo>
    }
    
    struct Output {
        let notis: Driver<[NotificationInfo]>
        let canLoad: Signal<Bool>
        let readNoti: Signal<Void>
        /// Int; QuestionId
        let showQuestionScene: Signal<Int>
        /// Int: CommentId
        let showCommentScene: Signal<Int>
    }
    
    private let notificationUseCase: NotificationUseCase
    
    init(notificationUseCase: NotificationUseCase) {
        self.notificationUseCase = notificationUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let newLoad = input.viewWillAppear
            .map { (page: 0,size: Constants.scrapFetchSize)}
            .flatMap(notificationUseCase.fetchNotifications)
            .debug()
            .compactMap {
                result -> [NotificationInfo]? in
                guard case let .success(notis) = result else { return nil }
                return notis
            }.map { NotiFetchAction.load(notis: $0)}
            .share()
        
        
        let moreLoad = input.moreFetch
            .map { (page: $0, size: Constants.scrapFetchSize) }
            .flatMap(notificationUseCase.fetchNotifications)
            .compactMap {
                result -> [NotificationInfo]? in
                guard case let .success(notis) = result else { return nil }
                return notis
            }.map { NotiFetchAction.loadMore(notis: $0)}
            .share()
        
        let load = Observable.merge(newLoad, moreLoad)
        
        let notis = load
            .scan(into: [NotificationInfo]()) { notis, action in
                switch action {
                case .load(let newNotis):
                    notis = newNotis
                case .loadMore(let newNotis):
                    notis += newNotis
                }
            }
        
        let canLoad = moreLoad
            .compactMap {
                action -> [NotificationInfo]? in
                guard case let .loadMore(notis) = action else { return nil}
                return notis
            }
            .map { $0.count == Constants.scrapFetchSize }
        
        let readNoti = input.didTapNotification
            .filter{ !$0.userRead }
            .map { $0.id }
            .flatMap(notificationUseCase.readNotification(_:))
            .mapToVoid()
        
        let showQuestionScene = input.didTapNotification
            .filter { $0.type == .question }
            .map { $0.contentId }
        
        let showCommentScene = input.didTapNotification
            .filter { $0.type == .reply || $0.type == .comment }
            .map { $0.contentId }
        
        
        return Output(
            notis: notis.asDriver(onErrorJustReturn: []),
            canLoad: canLoad.asSignal(onErrorSignalWith: .empty()),
            readNoti: readNoti.asSignal(onErrorSignalWith: .empty()),
            showQuestionScene: showQuestionScene.asSignal(onErrorSignalWith: .empty()),
            showCommentScene: showCommentScene.asSignal(onErrorSignalWith: .empty())
        )
    }
}
