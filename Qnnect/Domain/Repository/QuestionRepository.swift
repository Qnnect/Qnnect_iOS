//
//  QuestionRepository.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/10.
//

import Foundation
import RxSwift

protocol QuestionRepository: AnyObject {
    func scrap(_ questionId: Int) -> Observable<Result<Void,Error>>
    func cancleScrap(_ questionId: Int) -> Observable<Result<Void,Error>>
    func fetchAllScrap(_ page: Int, _ size: Int) -> Observable<Result<[QuestionShortInfo],Error>>
    func fetchScrap(_ cafeId: Int, _ page: Int, _ size: Int) -> Observable<Result<[QuestionShortInfo],Error>>
    func fetchCafes() -> Observable<Result<[CafeTag],Error>>
    func fetchQuestion(_ questionId: Int) -> Observable<Result<CafeQuestion,Error>>
    func modifyQuestion(_ questionId: Int, _ content: String) -> Observable<Result<Void,Error>>
    func deleteQuestion(_ questionId: Int) -> Observable<Result<Void,Error>>
    func searchScrap(_ page:Int, _ size: Int, _ searchWord: String) -> Observable<Result<[QuestionShortInfo],Error>>
    func like(_ questionId: Int, _ isUserLiked: Bool) -> Observable<Result<Void,Error>>
    
    func fetchCafeQuestions(cafeId: Int, page: Int, size: Int) -> Observable<Result<[QuestionShortInfo],Error>>
    func searchCafeQuestion(cafeId: Int, page: Int, size: Int, _ searchWord: String) -> Observable<Result<[QuestionShortInfo],Error>>
    func fetchAllUserQuestion(page:Int, size: Int) -> Observable<Result<[UserQuestion],Error>>
    func fetchUserQuestions(cafeId: Int, page: Int, size: Int) -> Observable<Result<[UserQuestion],Error>>
    func modifyUserQuestion(_ questionId: Int, _ content: String) -> Observable<Result<Void,Error>>
    func deleteUserQuestion(_ questionId: Int) -> Observable<Result<Void,Error>>
}
